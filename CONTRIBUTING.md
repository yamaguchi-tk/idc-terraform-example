# Contributing

English | [日本語](CONTRIBUTING.ja.md)

Thanks for your interest in contributing to idc-terraform-example!

This repository is a standalone sample of
[idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework) with
fictional data. Contributions here are welcome for fixing bugs in the sample, improving the
documentation, or aligning the structure with the framework.

## Reporting issues

Use [GitHub Issues](https://github.com/yamaguchi-tk/idc-terraform-example/issues) for bugs
or documentation problems.

## Submitting changes

1. Fork the repository and create a branch from `main`.
2. Make your change.
3. Validate it locally:
   ```sh
   cd terraform/root
   terraform init -backend=false
   terraform validate
   terraform fmt -check -recursive
   ```
4. Open a pull request against `main`.

## Rules for this repository specifically

- Never introduce real AWS account IDs, Identity Store IDs, email addresses, or
  organization/group names. Use fictional data only (e.g. `@example.com`, `111111111111`).
- If a change modifies the Terraform structure (not just sample data), consider whether the
  same change should also be made in
  [idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework), since
  this repository's code is a physical copy of it.

## License

By contributing, you agree that your contributions will be licensed under the
[Apache License 2.0](LICENSE).
