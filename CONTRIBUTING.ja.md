# Contributing

[English](CONTRIBUTING.md) | 日本語

idc-terraform-example への貢献に興味を持っていただきありがとうございます。

本リポジトリは [idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework)
を架空データで動かすスタンドアロンのサンプルです。サンプルの不具合修正、ドキュメント改善、
フレームワークとの構成の整合を取る変更などを歓迎します。

## バグ報告・質問

バグ報告やドキュメントの問題は [GitHub Issues](https://github.com/yamaguchi-tk/idc-terraform-example/issues)
をご利用ください。

## 変更の提出

1. リポジトリを fork し、`main` からブランチを作成する
2. 変更を加える
3. ローカルで検証する
   ```sh
   cd terraform/root
   terraform init -backend=false
   terraform validate
   terraform fmt -check -recursive
   ```
4. `main` に対してプルリクエストを作成する

## 本リポジトリ固有のルール

- 実際のAWSアカウントID・Identity Store ID・メールアドレス・組織名/グループ名は一切含めないで
  ください。架空データのみを使用してください（例: `@example.com`、`111111111111`）
- Terraformの構成そのものを変更する場合（サンプルデータのみの変更を除く）は、
  [idc-terraform-framework](https://github.com/yamaguchi-tk/idc-terraform-framework) 側にも
  同様の変更が必要か検討してください。本リポジトリのコードはフレームワークの物理コピーです

## ライセンス

貢献していただいた内容は [Apache License 2.0](LICENSE) の下でライセンスされることに
同意したものとみなされます。
