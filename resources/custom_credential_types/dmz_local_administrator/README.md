# "DMZ Local Administrator" Custom Credential Type

## Overview

This directory contains the injector and input configuration for the **DMZ Local Administrator** custom credential type.

## Contents

- [`injector.yml`](/resources/custom_credential_types/dmz_local_administrator/injector.yml) - injector configuration
- [`input.yml`](/resources/custom_credential_types/dmz_local_administrator/input.yml) - input configuration

## Usage

The **DMZ Local Administrator** custom credential type is used to safely inject the username and password consumed by the [`harden_2019_common`](/roles/harden_2019_common/) role, specifically the [`dmz`](/roles/harden_2019_common/tasks/dmz.yml) tasks. Said username and password are injected via `extra_vars` as `dmz_local_admin_name` and `dmz_local_admin_pass` respectively.

The `password` field in the input configuration is set as secret to ensure that the value is redacted in the Ansible job log output.
