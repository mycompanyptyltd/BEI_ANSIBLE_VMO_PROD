# Windows Server 2022 SOE Ansible Playbooks

## Overview

This repository contains a collection of Ansible playbooks, roles and accompanying resources that are required to provision and configure servers as per the [**Windows Server 2022 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108). The included Ansible playbooks and roles are intended to be executed via specially configured workflow jobs in Ansible AWX.

## Contents

The structure of this repository is aligned with the Ansible best practice ([Reference](https://docs.ansible.com/ansible/2.9/user_guide/playbooks_best_practices.html#directory-layout)). The root of the repository contains the following Ansible playbooks:

- [`add_host_to_inventory.yml`](/add_host_to_inventory.yml) - Adds targeted server to temporary server build AWX inventory.
- [`add_to_CMDB.yml`](/add_to_CMDB.yml) - Adds new server to ServiceNow CMDB upon a successful build.
- [`bootstrap_host.yml`](/bootstrap_host.yml) - Configures a host for management by Ansible.
- [`build_from_template.yml`](/build_from_template.yml) - Provisions a Windows Server 2019 VM from a template to a specified VMware environment.
- [`configure_soe.yml`](/configure_soe.yml) - Configures a server as per section **2.3** of the [**Windows Server 2019 SOE Specification**](https://nexus.watercorporation.com.au/otcs/cs.exe/app/nodes/124134108).
- [`configure_temp_local_admin.yml`](/configure_temp_local_admin.yml) - Creates a temporary local administrator account on the target server for use by Ansible.
- [`domain_join.yml`](/domain_join.yml) - Joins target server to the specified AD domain.
- [`fail_build.yml`](/fail_build.yml) - Fails server build for consistent output in AWX.
- [`send_build_email.yml`](/send_build_email.yml) - Sends server build success/failure e-mail messages.
- [`set_network_vmware.yml`](/set_network_vmware.yml) - Sets static IPv4 address and DNS server addresses in the guest OS as well as the Distributed Port Group of the VMware VM.

The remainder of the repository is structured as follows:

- [`/resources`](/resources/README.md) - additional resources required by or related to the Ansible playbooks and roles within this repository.
  - [`/resources/custom_credential_types`](/resources/custom_credential_types/README.md) - Custom Credential Types utilised by various Ansible roles.
- [`/roles`](/roles/README.md) - Ansible roles consumed by the playbooks within this repository.
