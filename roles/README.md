# Ansible Roles

## Overview

This folder contains Ansible roles that are utilised by the playbooks in the root of this repository. The directory structure aligns with Ansible best practice ([Reference](https://docs.ansible.com/ansible/2.9/user_guide/playbooks_best_practices.html#directory-layout)).

## Contents

>**NOTE:** the inclusion of the following Ansible roles within this repository does not indicate that said role is actively utilised. Role usage is dictated by the individual Ansible playbooks in the root of this repository.

- [`add_host_to_inventory`](/roles/add_host_to_inventory/) - Adds targeted server to temporary server build AWX inventory.
- [`configure_snmp_service`](/roles/configure_snmp_service/) - Configures the Windows SNMP Service as per section **2.3.3** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`configure_temp_local_admin`](/roles/configure_temp_local_admin/) - Creates a temporary local administrator account on the target server for use by Ansible for the duration of the build. Also creates a Scheduled Task to remove the temporary local administrator account after a defined duration.
- [`configure_winrm`](/roles/configure_winrm/) - Configures WinRM on a host using the [`ConfigureRemotingForAnsible.ps1`](https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1) PowerShell script.
- [`deploy_vm_from_template`](/roles/deploy_vm_from_template/) - Deploys a VMware Virtual Machine in the target environment using a specified template.
- [`disable_ie11`](/roles/disable_ie11/) - Removes Internet Explorer 11.
- [`domain_join_vm`](/roles/domain_join_vm/) - Joins target server to the specified AD domain.
- [`harden_2019_common`](/roles/harden_2019_common/) - Applies non-specific security hardening configuration to the target server as per section **2.3.4** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`harden_2019_core`](/roles/harden_2019_core/) - Applies Windows Server 2019 Core specific security hardening configuration to the target server as per section **2.3.4** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`harden_2019_gui`](/roles/harden_2019_gui/) - Applies Windows Server 2019 Desktop Experience specific security hardening configuration to the target server as per section **2.3.4** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_bginfo`](/roles/install_bginfo/) - Installs and configures [BgInfo](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo) as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_cw_agent`](/roles/install_cw_agent/) - Installs and configures the [Amazon CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html) as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_laps`](/roles/install_laps/) - Installs the [Local Administrator Password Solution (LAPS)](https://www.microsoft.com/en-us/download/details.aspx?id=46899) as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_mecm_client`](/roles/install_mecm_client/) - Installs the Microsoft Endpoint Configuration Manager client.
- [`install_nessus_agent`](/roles/install_nessus_agent/) - Installs the Tenable Nessus Agent as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_net_48`](/roles/install_net_48/) - Installs [Microsoft .NET Framework 4.8](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48) as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_sep_client`](/roles/install_sep_client/) - Installs the Symantec Endpoint Protection agent as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_splunk_agent`](/roles/install_splunk_agent/) - Installs the Splunk Universal Forwarder agent as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`install_ssm_agent`](/roles/install_ssm_agent/) - Installs the [AWS Systems Manager Agent (SSM Agent)](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html) as per section **2.3.5** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`send_build_email`](/roles/send_build_email/) - Sends build success/failure alert e-mail messages.
- [`set_cdrom_drive_letter`](/roles/set_cdrom_drive_letter/) - Sets the CD-ROM drive letter as per section **2.3.3** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`set_ip_address`](/roles/set_ip_address/) - Sets static IPv4 address and DNS client addresses as specified.
- [`set_soe_facts`](/roles/set_soe_facts/) - Sets facts and stats required by various roles.
- [`set_soe_reg_info`](/roles/set_soe_reg_info/) - Writes server build details to the Windows registry.
- [`set_vm_port_group`](/roles/set_vm_port_group/) - Sets the Distributed Port Group of the target VMware VM as specified.
- [`uninstall_snmp_service`](/roles/uninstall_snmp_service/) - Uninstalls the SNMP Service Windows feature.
- [`windows_settings_common`](/roles/windows_settings_common/) - Applies non-specific Windows configuration to the target server as per section **2.3.3** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`windows_settings_core`](/roles/windows_settings_core/) - Applies Windows Server 2019 Core specific Windows configuration to the target server as per section **2.3.3** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`windows_settings_gui`](/roles/windows_settings_gui/) - Applies Windows Server 2019 Desktop Experience specific Windows configuration to the target server as per section **2.3.3** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
