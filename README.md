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

## Prerequisites

Like the framework, this sample manages only the Identity Store (users and groups) and
permission assignments of AWS Identity Center. It assumes an external Identity Provider
(IdP) is already set up separately, and that users authenticate via SSO federated from
that IdP. Setting up the IdP itself or its federation with Identity Center is out of scope.

- AWS IAM Identity Center itself must already be enabled for your organization.
- Like the framework, this sample provisions Identity Store users directly via Terraform
  (`aws_identitystore_user`). If you base a real deployment on this sample, do not enable
  automatic (SCIM) provisioning from your IdP into Identity Center — SCIM
  auto-provisioning and Terraform-managed users conflict and can cause `terraform apply`
  to fail.

## Directory layout

```
terraform/
├── user/
│   ├── user.txt                          # fictional user email addresses (@example.com)
│   └── dummy.tf                          # CI diff-detection placeholder (see "CI/CD compatibility" below)
├── membership/
│   ├── platform-team.txt
│   ├── sales-ops.txt
│   ├── security-readonly.txt
│   └── dummy.tf
├── assignment/
│   ├── 111111111111/                     # fictional account ID
│   │   └── dummy.tf
│   ├── 222222222222/
│   │   └── dummy.tf
│   └── 333333333333/
│       └── dummy.tf
└── root/                               # Terraform engine physically copied from the framework
    ├── terraform.tf
    ├── variables.tf                      # identity_store_id is hardcoded to d-0000000000
    ├── users.tf
    ├── groups.tf
    ├── memberships.tf
    ├── assignments.tf
    ├── assignments_dummy.tf              # dummy module wiring for CI diff-detection (see below)
    └── permissionsets.tf                 # AWS managed policy examples + a DeveloperAccess example using an inline policy
```

## CI/CD compatibility (tfaction)

This sample includes a small addition the framework itself does not have: a `dummy.tf`
placeholder in every directory that contains only `.txt` files
(`terraform/user/`, `terraform/membership/`, `terraform/assignment/<account_id>/`), plus a
matching `module` block under `terraform/root/` for each of them (in `users.tf`,
`memberships.tf`, and `assignments_dummy.tf`).

Plain `terraform plan`/`apply` does not need this — the file lists are read directly via
`fileset()` regardless of whether a `.tf` file exists alongside them. This wiring exists
only for diff-based CI tools such as [tfaction](https://github.com/suzuki-shunsuke/tfaction),
which resolve a changed file path to a Terraform target through module dependencies. A
directory that contains only `.txt` files is not a Terraform module by itself, so without
this wiring such a tool may not recognize that, say, a change under
`terraform/assignment/111111111111/` should trigger a `plan`/`apply` of `terraform/root`.
Each `dummy.tf` is a no-op (`data "aws_ssoadmin_instances" "dummy" {}`); it exists only to
make the directory a valid module source, and it has no effect on Terraform itself.

If you fork the framework and don't use a diff-based CI tool, you can skip this pattern
entirely — it is not required for `terraform plan`/`apply` to work.

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

## Contributing

Bug reports, questions, and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Copyright 2026 yamaguchi-tk

Licensed under the [Apache License 2.0](LICENSE).
