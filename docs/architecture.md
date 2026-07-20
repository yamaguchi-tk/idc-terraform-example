# Architecture

English | [日本語](architecture.ja.md)

This document is based on `docs/architecture.md` of
[idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework), with
the differences specific to this repository (Examples) added.

## Overview

This repository is a standalone sample that runs the AWS Identity Center (formerly AWS
SSO) access-permission management mechanism with fictional data. The configuration is
list-driven (text-file driven): users, group memberships, and account permission
assignments are declared in text files, and the engine in `terraform/root/` expands them
into Terraform resources.

## Directory layout

- `terraform/assignment/`: places permission assignment lists in a directory per AWS
  account ID. Files follow the `<permission_set>_<USER|GROUP>.txt` format and list user
  names (the local part before `@` of an email address) or group names
- `terraform/membership/`: group membership lists. The file name itself becomes the group
  name, and the file content is user names (the local part before `@`)
- `terraform/user/`: `user.txt` is the list of email addresses used to create users in the
  Identity Store
- `terraform/root/`: the root module holding the Terraform definitions (where
  `terraform init/validate` is run). Includes `terraform.tf`, `assignments.tf`, `users.tf`,
  `groups.tf`, `memberships.tf`, `variables.tf`, and `permissionsets.tf`

## Differences specific to Examples (vs. the framework)

The structure is nearly identical to the framework, but since this is a sample that cannot
connect to a real AWS Identity Center, the following points differ.

- `identity_store_id`: the framework derives this dynamically from
  `data "aws_ssoadmin_instances"`, but this repository hardcodes a fictitious value
  (`"d-0000000000"`) directly as a `locals` value in `terraform/root/variables.tf`
- `aws_region`: like the framework, this is defined as a static `locals` value
  (`"ap-northeast-1"`) in `variables.tf`. This part of the structure is identical between
  the two repositories
- `terraform plan` / `terraform apply` cannot be run, because
  `data "aws_ssoadmin_instances" "instance" {}` requires a connection to a real AWS
  Identity Center. This repository is intended only for verifying syntax and logic via
  `terraform validate` / `terraform fmt`
- For this reason, as with the framework, `variables.tf` contains no `variable` blocks at
  all

## Notes when making changes

- Before adding a membership or an assignment, always add the user to
  `terraform/user/user.txt` first
- Membership and assignment lists use user names (the part before `@`), not full email
  addresses
- Assignment files are registered in `assignment_target_groups` /
  `assignment_target_users` in `terraform/root/variables.tf`. When adding a file for a new
  PermissionSet, add the resource in `permissionsets.tf` and also add the corresponding
  `file_name` / `permission_set_arn` / `principal_type` mapping in `variables.tf`
- Adding a new AWS account only requires creating a new directory under
  `terraform/assignment/`. `assignment_target_aws_accounts` in `variables.tf`
  auto-discovers it via `fileset`
- This repository intentionally does not include CI/CD configuration (e.g. GitHub
  Actions)
