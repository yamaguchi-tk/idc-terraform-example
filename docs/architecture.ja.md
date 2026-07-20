# アーキテクチャ

[English](architecture.md) | 日本語

このドキュメントは [idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework)
の `docs/architecture.md` をベースに、本リポジトリ（Examples）固有の差異を追記したものです。

## 概要

このリポジトリは AWS Identity Center (旧 AWS SSO) のアクセス権限を Terraform で管理する仕組みを、
架空データを使ってスタンドアロンで動かすサンプルです。構成は list-driven（テキストファイル駆動）で、
ユーザー・グループメンバーシップ・アカウントへの権限割当をテキストファイルで宣言し、
`terraform/root/` のエンジンがそれを Terraform リソースとして展開します。

## ディレクトリ構成

- `terraform/assignment/`: AWSアカウントIDごとのディレクトリに権限割当リストを配置する。
  ファイルは `<permission_set>_<USER|GROUP>.txt` の形式で、ユーザー名（メールアドレスの`@`より
  前の部分）またはグループ名を列挙する
- `terraform/membership/`: グループメンバーシップのリスト。ファイル名がそのままグループ名になり、
  ファイルの中身はユーザー名（メールアドレスの`@`より前の部分）
- `terraform/user/`: `user.txt` は Identity Store にユーザーを作成するためのメールアドレス一覧
- `terraform/root/`: Terraformの定義を置くルートモジュール（`terraform init/validate`を実行する
  場所）。`assignments.tf`, `users.tf`, `groups.tf`, `memberships.tf`, `variables.tf`,
  `permissionsets.tf` を含む

## Examples固有の差異（フレームワークとの違い）

フレームワークとほぼ同じ構成ですが、実際のAWS Identity Centerに接続できないサンプルであるため、
以下の点が異なります。

- `identity_store_id`: フレームワークでは `data "aws_ssoadmin_instances"` から動的に導出するが、
  本リポジトリでは `terraform/root/variables.tf` の `locals` に架空値 `"d-0000000000"` を
  直接埋め込んでいる
- `aws_region`: フレームワークと同様、`variables.tf` の `locals` に静的な値（`"ap-northeast-1"`）
  として定義している。この点は両リポジトリで構成が同じ
- `terraform plan` / `terraform apply` は実行できない。`data "aws_ssoadmin_instances" "instance" {}`
  が実際の AWS Identity Center への接続を要求するため。`terraform validate` / `terraform fmt`
  までの構文・ロジック確認用と割り切っている
- 上記の理由により、フレームワークと同様に `variables.tf` には `variable` ブロックが1つも
  含まれない

## 変更時の注意

- メンバーシップや権限割当を追加する前に、必ず `terraform/user/user.txt` にユーザーを追加すること
- メンバーシップ・権限割当のリストは、メールアドレス全体ではなくユーザー名（`@`より前の部分）を使う
- 権限割当ファイルは `terraform/root/variables.tf` の `assignment_target_groups` /
  `assignment_target_users` に登録されている。新しい PermissionSet のファイルを追加する場合は、
  `permissionsets.tf` にリソースを追加した上で `variables.tf` にも `file_name` /
  `permission_set_arn` / `principal_type` のマッピングを追加すること
- 新しいAWSアカウントの追加は `terraform/assignment/` 配下に新しいディレクトリを作るだけでよい。
  `variables.tf` の `assignment_target_aws_accounts` が `fileset` で自動検出する
- 本リポジトリは意図的に CI/CD 設定（GitHub Actions 等）を含まない
