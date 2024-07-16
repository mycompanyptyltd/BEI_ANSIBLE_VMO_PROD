# "SNMP Details" Custom Credential Type

## Overview

This directory contains the injector and input configuration for the **SNMP Details** custom credential type.

## Contents

- [`injector.yml`](/resources/custom_credential_types/snmp_details/injector.yml) - injector configuration
- [`input.yml`](/resources/custom_credential_types/snmp_details/input.yml) - input configuration

## Usage

The **SNMP Details** custom credential type is used to safely inject SNMP community strings for consumption by the  [`configure_snmp_service`](/roles/configure_snmp_service/) role. Read and write community strings are injected via `extra_vars` as `snmp_read` and `snmp_write` respectively.

The `snmp_read` and `snmp_write` fields in the input configuration are set as secret to ensure that their value is redacted in the Ansible job log output.
