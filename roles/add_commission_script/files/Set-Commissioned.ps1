#region Header
<#  
.SYNOPSIS
    This script is run to commission a server that was built for a project and not immediately commissioned

.DESCRIPTION
    This script performs the following actions:
    * Update BGinfo
    * Add Commissioned Date to registry
    * Update CA Spectrum Maintenance for object
    Script has been created through merge of original "Set-Commissioned.ps1" and "Set-Maintenance.ps1" build scripts
    and adapted for utilisation by Server 2019 SOE build process through Ansible. 

.NOTES  
    Original Author: Glen Buktenica
    Adapted By     : Nick Trajanovski
    Version        : 20221006

#>
[CmdletBinding()]
Param
(
    [string]$Spectrum = "http://Spectrum/spectrum/restful/",
    [string]$username = "caservice",
    [string]$password = -join('286E45387635357622284465682325' -split '(?<=\G.{2})',15|%{[char][int]"0x$_"}),
    [switch]$Logging #= $true # decomment line to force logging.
)

$XMLHeader = @'
<?xml version="1.0" encoding="UTF-8"?>
<rs:model-request throttlesize="5"
xmlns:rs="http://www.ca.com/spectrum/restful/schema/request"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.ca.com/spectrum/restful/schema/request ../../../xsd/Request.xsd ">
<rs:target-models>
<rs:models-search>
<rs:search-criteria xmlns="http://www.ca.com/spectrum/restful/schema/filter">
<action-models>
<filtered-models>
<equals>
<model-type>SearchManager</model-type>
</equals>
</filtered-models>
<action>FIND_DEV_MODELS_BY_IP</action>
<attribute id="AttributeID.NETWORK_ADDRESS">
<value>
'@

$XMLFooter = @'
</value>
</attribute>
</action-models>
</rs:search-criteria>
</rs:models-search>
</rs:target-models>
<rs:requested-attribute id="0x1006e" />
<rs:requested-attribute id="0x1295d" />
</rs:model-request>
'@

#region Functions

Function Configure-Logs
{
    <#  
    .SYNOPSIS  
        Configure standard and error log file paths for use by Export-Logs.

    .PARAMETER [boolean] System
        Use %System Temp% for log paths instead of script path.

    .PARAMETER [boolean] Logging
        If Logging True starts transcription logging and verbose output.

    .EXAMPLE
        Configure-Logs should be the first function called.

    .OUTPUTS
        [string]  LogPath                   Transcripting output
        [string]  ErrorPath                 Standard error output
        [boolean] Global:VerbosePreference  Enables verbose screen output

    .NOTES  
        Author        : Glen Buktenica
        Prerequisites : PowerShell Version 2
	    Version       : 2.0.2.0 20170428 Public Release 
    #> 
    [CmdletBinding()]
    Param
    (
        [switch]$SystemTemp
    ) 
    If ($global:Logging)
    {
        $global:VerbosePreference = "continue"
    }
    If ($PSVersionTable.PSVersion.Major -ge 3)
    {
        $global:ErrorActionIgnore = "Ignore"
    }
    else
    {
        $global:ErrorActionIgnore = "SilentlyContinue"
    }
    If ($MyInvocation.ScriptName) #Confirm script has been saved
    {
        # Create log paths in the same location as the script
        $CurrentPath = Split-Path $MyInvocation.ScriptName
        $ScriptName  = [io.path]::GetFileNameWithoutExtension($MyInvocation.ScriptName)
        $LogPathDate = Get-Date -Format yyyyMMdd
        If ($SystemTemp)
        {
            $global:OutFilePath = "$env:windir\temp\$ScriptName$LogPathDate" # Example C:\Windows\temp\MyScript20160329
        }
        Else
        {
            $global:OutFilePath = "$CurrentPath\$ScriptName$LogPathDate"     # Example c:\scripts\MyScript20160329
        }
        Try
        {
            # Test that log file location is able to be written to
            " " | Out-File "$global:OutFilePath.test" -Force
        }
        Catch
        {
            # If log file location not writable save to Temp
            $global:OutFilePath = "$env:temp\$ScriptName$LogPathDate"       # Example C:\Users\glen\AppData\Local\temp\MyScript20160329
        }
        Finally
        {
            # Clean up test file
            $global:LogPath     = "$global:OutFilePath.log"
            $global:ErrorPath   = "$global:OutFilePath.err.log"
            Remove-Item "$global:OutFilePath.test" -ErrorAction $global:ErrorActionIgnore
        }
        Write-Verbose $OutFilePath
        Write-Verbose $LogPath
        Write-Verbose $ErrorPath
        # Start standard logging if NOT running in PowerShell ISE and logging enabled and the log path is valid.
        If(($PSVersionTable.PSVersion.Major -ge 5 -or $Host.UI.RawUI.BufferSize.Height -gt 0) -and ($Logging) -and ($LogPath)) 
        {
            $global:Transcripting = $true
            Start-Transcript -Path $LogPath -append
        }
        # Clear standard error in case populated by previous scripts
        $Error.Clear()
    }
}
Function Export-Logs
{
    <#  
    .SYNOPSIS  
        If the standard error variable is populated then all errors will be saved to a text file.

    .EXAMPLE
        Export-Logs should be the last line in a script and/or called before Exit command.

    .INPUTS
        Global errors.

    .OUTPUTS
        [text file] In the current script path or if not writeable in the user local temp path.

    .NOTES  
        Author        : Glen Buktenica
        Prerequisites : PowerShell Version 2
	    Version       : 2.0.3.0 20170509 Public Release 
    #> 
    [CmdletBinding()]
    Param()
    If ($Error -and $ErrorPath)
    {
        Write-Verbose "Errors were found"
        Get-Date -Format "dddd, d MMMM yyyy HH:mm" | Out-File -FilePath $ErrorPath -Append
        "User name: $env:USERNAME"  | Out-File -FilePath $ErrorPath -Append
        "Computer name: $env:COMPUTERNAME" | Out-File -FilePath $ErrorPath -Append
        "PowerShell Version: " + ($PSVersionTable.PSVersion).ToString() | Out-File -FilePath $ErrorPath -Append
        # All errors in $Error are FILO. Reversing $Error so errors are exported in chronological order.
        $Error.Reverse()
        # Loop through each error, getting detailed error information and write to error log file
        $Error | ForEach-Object {"--------------------------------------------------"
            "Exception:"
            $_.Exception
            "FullyQualifiedErrorId:"
            $_.FullyQualifiedErrorId
            "ScriptStackTrace:"
            $_.ScriptStackTrace
            $ScriptLineNumber = $_.InvocationInfo.ScriptLineNumber 
            "Error line:  $ScriptLineNumber"
            $_.CategoryInfo } | Out-File -FilePath $ErrorPath -append
        # Export Variables except for automatically generated or sensitive variables.
        If ($Logging)
        {
            $AutomaticVariables = @('$','?','^','Credential','ErrorPath','Logging','LogPath','Password','sPassword','ScriptLineNumber','args','AutomaticVariables','ConfirmPreference','ConsoleFileName','DebugPreference','Error','ErrorActionPreference','ErrorView','ExecutionContext','false','FormatEnumerationLimit','HOME','Host','InformationPreference','input','MaximumAliasCount','MaximumDriveCount','MaximumErrorCount','MaximumFunctionCount','MaximumHistoryCount','MaximumVariableCount','MyInvocation','NestedPromptLevel','null','OutputEncoding','PID','profile','ProgressPreference','PSBoundParameters','PSCmdlet','PSCommandPath','PSCulture','PSDefaultParameterValues','PSEmailServer','PSHOME','psISE','PSScriptRoot','PSSessionApplicationName','PSSessionConfigurationName','PSSessionOption','PSUICulture','psUnsupportedConsoleApplications','PSVersionTable','PWD','ShellId','StackTrace','true','VerbosePreference','WarningPreference','WhatIfPreference')
            $AutomaticVariables = Compare-Object (Get-Variable).Name $AutomaticVariables -PassThru -ErrorAction $global:ErrorActionIgnore
            "Variables: " | Out-File -FilePath $ErrorPath -Append
            Get-Variable -Name $AutomaticVariables  -ErrorAction $global:ErrorActionIgnore | ForEach-Object {"----------------------------"
                "Name:"
                $_.Name
                "Value:"
                $_.Value
                } | Out-File -FilePath $ErrorPath -Append
        }
    }
    # If transcripting started, stop the transcript
    Try{If($Transcripting)
    {Stop-Transcript | Out-Null}}
    Catch [System.InvalidOperationException]{$error.Remove($error[0])}

    Write-Verbose "Script End"
    If ($Logging){Start-Sleep -s 10}
    $global:Logging = $false
    $global:VerbosePreference = "SilentlyContinue"
}

#endregion Functions
#endregion Header

#region Main
Configure-Logs

$sPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $sPassword)
$IPAddresses = @()

#Update target BGInfo file
Write-Verbose "Update BGInfo File"
$ShortcutFile = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Start-BGinfo.lnk"

$shell = New-Object -ComObject Wscript.Shell
$lnk = $shell.createShortcut($ShortcutFile.Fullname)
$lnk.Arguments = $lnk.Arguments -replace "Non",""
$lnk.Save()

#Relaunch BGInfo
Start-Process -FilePath $ShortcutFile.Fullname

#Remove old non-commissioned files
$OldBGFiles = Get-ChildItem -path "C:\Program Files\BGInfo\" -filter *.bgi | Where-Object {$_.Name -like "Non*"}
foreach ($OldBGFile in $OldBGFiles) {
    Remove-Item $OldBGFile.FullName -force -ErrorAction Ignore | Out-Null
}

#Add Commissioned date to Registry
Write-Verbose "Write Commissioned Date to registry"
$CommissionedDate = Get-Date -UFormat "%Y%m%d"
New-ItemProperty -Path HKLM:\Software\SOE -Name Commissioned -Value Yes -force | Out-Null
New-ItemProperty -Path HKLM:\Software\SOE -Name ServerCommissionedDate -Value $CommissionedDate -force | Out-Null

#Remove from CA Spectrum Maintenance mode
Write-Verbose "Setting Spectrum mode to Managed"
$URI = $Spectrum + "models"
$IPAddresses = @()
$IPAddresses = (Get-NetIPAddress).ipaddress | Where-Object {$_ -ne "127.0.0.1" -and $_ -ne "::1"}
$IPAddresses = $IPAddresses | Get-Unique

Foreach ($IP in $IPAddresses)
{
    Write-Verbose "------------------------------------------"
    Write-Verbose "Getting Model ID for IP Address:"
    Write-Verbose $IP
    $XML = $XMLHeader + $IP + $XMLFooter
    $Body = [byte[]][char[]]$XML
    Write-Debug $XML
    $Request = [System.Net.HttpWebRequest]::CreateHttp($URI)
    $Request.Method = 'POST'
    $Request.KeepAlive = $false
    $Request.Credentials = New-Object System.Net.NetworkCredential($username, $password)
    $Stream = $Request.GetRequestStream()
    $Stream.Write($Body, 0, $Body.Length)
    $Stream.Close()
    Try
    {
        $Response = $Request.GetResponse().getresponsestream() 
    }
    Catch
    {
        Write-Error "Communication with Spectrum failed. Update manually."
        return
    }
    $Reader = New-Object System.IO.StreamReader($Response)
    $ResponseText = [xml]$Reader.ReadToEnd()

    $Reader.Close()
    $Stream.Dispose()
    $Response.Close()

    $ModelResponses = $ResponseText.'model-response-list'.'model-responses'.model
    If ($ModelResponses.mh.length -gt 0)
    {
        Write-Debug $ModelResponses
    }
    Else
    {
        Write-Error "$IP not found in CA Spectrum"
    }
    ForEach ($ModelResponse in $ModelResponses)
    {
        If ($ModelResponse.mh.length -gt 0)
        {
            $ModelID = $ModelResponse.mh
            $ModelHostName = $ModelResponse.attribute[0].'#text'
            $ModelCurrentManagedMode = $ModelResponse.attribute[1].'#text'
            Write-Verbose "Model ID returned:"
            Write-Verbose $ModelID
            Write-Verbose "Model Hostname returned:"
            Write-Verbose $ModelHostName
            Write-Verbose "Model Current Managed Mode:"
            Write-Verbose $ModelCurrentManagedMode
            #Set managed state
            $URIPut = $Spectrum + "model/" + $ModelID + "?attr=0x1295d&val=" + "true"
            Write-Verbose "URI sent to Spectrum:"
            Invoke-RestMethod -Uri $URIPut -Credential $Credential -Method Put | Out-Null

            # Set Comment
            $URIPutNotes = $Spectrum + "model/" + $ModelID + "?attr=0x11564&val="
            Invoke-RestMethod -Uri $URIPutNotes -Credential $Credential -Method Put | Out-Null 

            # Read back managed status to confirm the update was successful.
            $URIPutCheck = $Spectrum + "model/" + $ModelID + "?attr=0x1295d"
            Write-Verbose "URI sent to Spectrum:"
            $Result = (Invoke-RestMethod -Uri $URIPutCheck -Credential $Credential -Method Get).'model-response-list'.'model-responses'.model.attribute.'#text'
            If ($Result -ne "true")
            {
                Write-Warning "Failed to update Model ID $ModelID with IP address $IP" 
            }
            Else
            {
                Write-Output "Updated managed mode of Model ID $ModelID with IP address $IP to true"
            }
        }
 
        Else
        {
            Write-Verbose "No Model ID found"
        }
    }
}

Remove-Item "C:\Users\Public\Desktop\Set-Commissioned.lnk" -force -ErrorAction Ignore | Out-Null
Remove-Item "C:\Temp\Set-Commissioned.bat" -force -ErrorAction Ignore | Out-Null
Remove-Item "C:\Temp\Set-Commissioned.ps1" -force -ErrorAction Ignore | Out-Null
Start-Sleep -s 5
#endregion Main
Export-Logs