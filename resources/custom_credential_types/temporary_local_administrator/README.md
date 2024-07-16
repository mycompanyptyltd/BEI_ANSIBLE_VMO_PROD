# "Temporary Local Administrator" Custom Credential Type

## Overview

This directory contains the injector and input configuration for the **Temporary Local Administrator** custom credential type.

## Contents

- [`injector.yml`](/resources/custom_credential_types/temporary_local_administrator/injector.yml) - injector configuration
- [`input.yml`](/resources/custom_credential_types/temporary_local_administrator/input.yml) - input configuration

## Usage

The **Temporary Local Administrator** custom credential type is used to safely inject the username and password consumed by the [`configure_temp_local_admin`](/roles/configure_temp_local_admin/) role. Said username and password are injected via `extra_vars` as `temp_admin_name` and `temp_admin_pass` respectively.

The `password` field in the input configuration is set as secret to ensure that the value is redacted in the Ansible job log output.
