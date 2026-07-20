# idc-terraform-example

[English](README.md) | 日本語

[idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework) の
list-driven な AWS Identity Center 管理の仕組みを、架空データで動かしたスタンドアロンの
サンプルリポジトリです。フレームワークの Terraform コードを物理コピーしており、
module 参照は行っていません。

## このリポジトリについて

- ここに含まれるアカウントID・Identity Store ID・メールアドレス・グループ名・
  PermissionSet 名はすべて架空のものです（実在の組織・システムとは関係ありません）
- `terraform plan` / `terraform apply` は実行できません。
  `data "aws_ssoadmin_instances" "instance" {}` が実際の AWS Identity Center への
  接続を要求するためです。あくまで構文・展開ロジックを確認するためのサンプルです
- `terraform validate` / `terraform fmt` までは実行して確認できます

## 前提条件

フレームワークと同様、本サンプルが管理するのは AWS Identity Center の Identity Store
（ユーザー・グループ）と権限割当のみです。外部の Identity Provider (IdP) が別途構築済みであり、
その IdP からの SSO でユーザー認証を行うことを前提としています。IdP自体の構築や Identity Center
との連携設定は本リポジトリのスコープ外です。

- AWS IAM Identity Center 自体が組織で有効化済みであることも前提です。
- フレームワークと同様、本サンプルは Terraform (`aws_identitystore_user`) で Identity Store の
  ユーザーを直接作成します。本サンプルを元に実環境を構築する場合は、IdP側からIdentity Centerへの
  自動プロビジョニング（SCIM）を有効にしないでください。SCIM自動プロビジョニングとTerraform管理の
  ユーザーは競合し、`terraform apply`が失敗する原因になります。

## ディレクトリ構成

```
terraform/
├── user/
│   └── user.txt                          # 架空ユーザーのメールアドレス一覧（@example.com）
├── membership/
│   ├── platform-team.txt
│   ├── sales-ops.txt
│   └── security-readonly.txt
├── assignment/
│   ├── 111111111111/                     # 架空アカウントID
│   ├── 222222222222/
│   └── 333333333333/
└── root/                               # フレームワークから物理コピーしたTerraformエンジン
    ├── terraform.tf
    ├── variables.tf                      # identity_store_id は d-0000000000 をハードコード
    ├── users.tf
    ├── groups.tf
    ├── memberships.tf
    ├── assignments.tf
    └── permissionsets.tf                 # AWS管理ポリシー例 + inline policyを使うDeveloperAccess例
```

## サンプルデータの構成

| グループ | メンバー |
|---|---|
| platform-team | alice, bob, carol |
| sales-ops | dave, erin |
| security-readonly | frank, grace, heidi |

| アカウントID | 割当内容 |
|---|---|
| 111111111111 | AdministratorAccess: platform-team, ivan(USER) / ReadOnlyAccess: security-readonly |
| 222222222222 | PowerUserAccess: platform-team, sales-ops / DeveloperAccess: platform-team / ReadOnlyAccess: judy(USER) |
| 333333333333 | ReadOnlyAccess: sales-ops, security-readonly / DeveloperAccess: ivan, judy(USER) |

## 動作確認方法

```sh
cd terraform/root
terraform init -backend=false
terraform validate
terraform fmt -check -recursive
```

仕組みの詳細は [idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework)
の README / docs/architecture.md を参照してください。

## License

Copyright 2026 yamaguchi-tk

Licensed under the [Apache License 2.0](LICENSE).
