# Windows Server 2022 CIS
## Configure a Microsoft Server 2022 machine to be [CIS](https://www.cisecurity.org/cis-benchmarks/) compliant

### Based on [ CIS Microsoft Windows Server 2022 v2.0.0 - 04-14-2023 ](https://www.cisecurity.org/cis-benchmarks/)

---

![Org Stars](https://img.shields.io/github/stars/ansible-lockdown?label=Org%20Stars&style=social)
![Stars](https://img.shields.io/github/stars/ansible-lockdown/Windows-2022-CIS?label=Repo%20Stars&style=social)
![Forks](https://img.shields.io/github/forks/ansible-lockdown/Windows-2022-CIS?style=social)
![followers](https://img.shields.io/github/followers/ansible-lockdown?style=social)
[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/AnsibleLockdown.svg?style=social&label=Follow%20%40AnsibleLockdown)](https://twitter.com/AnsibleLockdown)

![Discord Badge](https://img.shields.io/discord/925818806838919229?logo=discord)

[![Devel Pipeline Status](https://github.com/ansible-lockdown/Windows-2022-CIS/actions/workflows/devel_pipeline_validation.yml/badge.svg?)](https://github.com/ansible-lockdown/Windows-2022-CIS/actions/workflows/devel_pipeline_validation.yml)
![Devel Commits](https://img.shields.io/github/commit-activity/m/ansible-lockdown/Windows-2022-CIS/devel?color=dark%20green&label=Devel%20Branch%20Commits)

![Release Branch](https://img.shields.io/badge/Release%20Branch-Main-brightgreen)
[![Main Pipeline Status](https://github.com/ansible-lockdown/Windows-2022-CIS/actions/workflows/main_pipeline_validation.yml/badge.svg?)](https://github.com/ansible-lockdown/Windows-2022-CIS/actions/workflows/main_pipeline_validation.yml)
![Main Release Date](https://img.shields.io/github/release-date/ansible-lockdown/Windows-2022-CIS?label=Release%20Date)
![Release Tag](https://img.shields.io/github/v/tag/ansible-lockdown/Windows-2022-CIS?label=Release%20Tag&&color=success)

![Issues Open](https://img.shields.io/github/issues-raw/ansible-lockdown/Windows-2022-CIS?label=Open%20Issues)
![Issues Closed](https://img.shields.io/github/issues-closed-raw/ansible-lockdown/Windows-2022-CIS?label=Closed%20Issues&&color=success)
![Pull Requests](https://img.shields.io/github/issues-pr/ansible-lockdown/Windows-2022-CIS?label=Pull%20Requests)

![License](https://img.shields.io/github/license/ansible-lockdown/Windows-2022-CIS?label=License)

---

## Looking for support?

[Lockdown Enterprise](https://www.lockdownenterprise.com#GH_AL_WINDOWS_2022_cis)

[Ansible support](https://www.mindpointgroup.com/cybersecurity-products/ansible-counselor#GH_AL_WINDOWS_2022_cis)

### Community

On our [Discord Server](https://www.lockdownenterprise.com/discord) to ask questions, discuss features, or just chat with other Ansible-Lockdown users

---

## Caution(s)

This role **will make changes to the system** which may have unintended consequences. This is not an auditing tool but a remediation tool to be used after an audit.

Check Mode is not supported! The role will be completed in check mode without errors, but it is not supported and should be used with caution.

This role was developed against a clean install of the Windows 2022 Operating System. If you are implementing an existing system please review this role for any site-specific changes that are needed.

To use the release version please point to the main branch and relevant release for the cis benchmark you wish to work with.

---

## Matching a security Level for CIS

It is possible to only run level 1 or level 2 controls for CIS.
This is managed using tags:

- level1-domaincontroller
- level1-memberserver
- level2-domaincontroller
- level2-memberserver

The control found in defaults/main.yml also needs to reflect this as this controls the testing that takes place if you are using the audit component.

## Coming from a previous release

CIS release always contains changes, so it is highly recommended to review the new references and available variables. This has changed significantly since the ansible-lockdown initial release.
This is now compatible with python3 if it is found to be the default interpreter. This does come with prerequisites that configure the system accordingly.

Further details can be seen in the [Changelog](./ChangeLog.md)

## Auditing (new)

Currently, this release does not have an auditing tool that is up to date.

## Documentation

- [Read The Docs](https://ansible-lockdown.readthedocs.io/en/latest/)
- [Getting Started](https://www.lockdownenterprise.com/docs/getting-started-with-lockdown#GH_AL_WINDOWS_2022_cis)
- [Customizing Roles](https://www.lockdownenterprise.com/docs/customizing-lockdown-enterprise#GH_AL_WINDOWS_2022_cis)
- [Per-Host Configuration](https://www.lockdownenterprise.com/docs/per-host-lockdown-enterprise-configuration#GH_AL_WINDOWS_2022_cis)
- [Getting the Most Out of the Role](https://www.lockdownenterprise.com/docs/get-the-most-out-of-lockdown-enterprise#GH_AL_WINDOWS_2022_cis)

## Requirements

**General:**

- Basic knowledge of Ansible, below are some links to the Ansible documentation to help get started if you are unfamiliar with Ansible

  - [Main Ansible documentation page](https://docs.ansible.com)
  - [Ansible Getting Started](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
  - [Tower User Guide](https://docs.ansible.com/ansible-tower/latest/html/userguide/index.html)
  - [Ansible Community Info](https://docs.ansible.com/ansible/latest/community/index.html)
- Functioning Ansible and/or Tower Installed, configured, and running. This includes all of the base Ansible/Tower configurations, needed packages installed, and infrastructure setup.
- Please read through the tasks in this role to gain an understanding of what each control is doing. Some of the tasks are disruptive and can have unintended consequences in a live production system. Also, familiarize yourself with the variables in the defaults/main.yml file.

**Technical Dependencies:**

- Windows 2022 - Other versions are not supported
- Running Ansible/Tower setup (this role is tested against Ansible version 2.9.1 and newer)
- Python3 Ansible run environment
- passlib (or python2-passlib, if using python2)
- python-lxml
- python-xmltodict
- python-jmespath
- pywinrm

Package 'python-xmltodict' is required if you enable the OpenSCAP tool installation and run a report. Packages python(2)-passlib and python-jmespath are required for tasks with custom filters or modules. These are all required on the controller host that executes Ansible.

## Role Variables

This role is designed so that the end user should not have to edit the tasks themselves. All customizing should be done via the defaults/main.yml file or with extra vars within the project, job, workflow, etc.

## Tags

There are many tags available for added control precision. Each control has its own set of tags noting what level, what OS element it relates to if it's a patch or audit, and the rule number.

Below is an example of the tag section from a control within this role. Using this example if you set your run to skip all controls with the tag smb, this task will be skipped. The opposite can also happen where you run only controls tagged with smb.

```sh
      tags:
      - level1-domaincontroller
      - level1-memberserver
      - rule_18.3.3
      - patch
      - smb
```

## Community Contribution

We encourage you (the community) to contribute to this role. Please read the rules below.

- Your work is done in your own individual branch. Make sure to Signed-off-by and GPG sign all commits you intend to merge.
- All community Pull Requests are pulled into the devel branch
- Pull Requests into devel will confirm your commits have a GPG signature, Signed-off-by, and a functional test before being approved
- Once your changes are merged and a more detailed review is complete, an authorized member will merge your changes into the main branch for a new release

## Pipeline Testing

uses:

- ansible-core 2.12
- ansible collections - pulls in the latest version based on the requirements file
- runs the audit using the devel branch
- This is an automated test that occurs on pull requests into devel
