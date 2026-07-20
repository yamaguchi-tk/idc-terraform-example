# idc-terraform-example

English | [日本語](README.ja.md)

A standalone sample repository that runs the list-driven AWS Identity Center management
approach from [idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework)
with fictional data. The Terraform code is physically copied from the framework; there is
no module reference.

## About this repository

- All account IDs, Identity Store IDs, email addresses, group names, and PermissionSet
  names included here are entirely fictional (unrelated to any real organization or system)
- `terraform plan` / `terraform apply` cannot be run, because
  `data "aws_ssoadmin_instances" "instance" {}` requires a connection to a real AWS Identity
  Center. This is a sample intended only for checking syntax and expansion logic
- `terraform validate` / `terraform fmt` can be run to verify the configuration

## Directory layout

```
terraform/
├── user/
│   └── user.txt                          # fictional user email addresses (@example.com)
├── membership/
│   ├── platform-team.txt
│   ├── sales-ops.txt
│   └── security-readonly.txt
├── assignment/
│   ├── 111111111111/                     # fictional account ID
│   ├── 222222222222/
│   └── 333333333333/
└── root/                               # Terraform engine physically copied from the framework
    ├── terraform.tf
    ├── variables.tf                      # identity_store_id is hardcoded to d-0000000000
    ├── users.tf
    ├── groups.tf
    ├── memberships.tf
    ├── assignments.tf
    └── permissionsets.tf                 # AWS managed policy examples + a DeveloperAccess example using an inline policy
```

## Sample data layout

| Group | Members |
|---|---|
| platform-team | alice, bob, carol |
| sales-ops | dave, erin |
| security-readonly | frank, grace, heidi |

| Account ID | Assignments |
|---|---|
| 111111111111 | AdministratorAccess: platform-team, ivan(USER) / ReadOnlyAccess: security-readonly |
| 222222222222 | PowerUserAccess: platform-team, sales-ops / DeveloperAccess: platform-team / ReadOnlyAccess: judy(USER) |
| 333333333333 | ReadOnlyAccess: sales-ops, security-readonly / DeveloperAccess: ivan, judy(USER) |

## How to verify

```sh
cd terraform/root
terraform init -backend=false
terraform validate
terraform fmt -check -recursive
```

For details on how this works, see the README / docs/architecture.md in
[idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework).

## License

Copyright 2026 yamaguchi-tk

Licensed under the [Apache License 2.0](LICENSE).
