# このファイルはフレームワーク(idc-terraform-framework)のvariables.tfと同名だが、
# 本リポジトリはサンプルのため実際のAWS Identity Centerに接続できない。
# そのためフレームワークではdata sourceから動的に導出しているidentity_store_idを、
# ここでは架空値でハードコードしている。variableブロックは持たない点はフレームワークと共通。
#
# This file shares its name with variables.tf in the framework (idc-terraform-framework),
# but this repository is a sample and cannot connect to a real AWS Identity Center.
# While the framework derives identity_store_id dynamically from a data source,
# here it is hardcoded to a fictitious value. Like the framework, this file has no variable blocks.
data "aws_ssoadmin_instances" "instance" {}

locals {
  # AWS Identity Center を管理する AWS リージョン
  # AWS region where AWS Identity Center is managed
  aws_region = "ap-northeast-1"

  # サンプルのため Identity Store ID は架空値をハードコードしている
  # Identity Store ID is hardcoded to a fictitious value for this sample
  identity_store_id = "d-0000000000"

  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]

  assignment_file_path = "../assignment"
  # assignment配下のフォルダ(AWSアカウントID)を列挙
  # Enumerate the folders (AWS account IDs) under assignment/
  assignment_target_aws_accounts = distinct([
    for file in fileset(local.assignment_file_path, "*/*.txt") : dirname(file)
  ])

  membership_file_path = "../membership"
}

locals {
  # assignment_targets の定義
  # 利用するPermissionSetを増やす場合は、file_name / permission_set_arn / principal_type（"GROUP" または "USER"）のマッピングを追加する
  # Definition of assignment_targets.
  # To add a PermissionSet to use, add a mapping of file_name / permission_set_arn / principal_type ("GROUP" or "USER").
  assignment_target_groups = [
    {
      file_name          = "AdministratorAccess_GROUP.txt"
      permission_set_arn = aws_ssoadmin_permission_set.AdministratorAccess.arn
      principal_type     = "GROUP"
    },
    {
      file_name          = "PowerUserAccess_GROUP.txt"
      permission_set_arn = aws_ssoadmin_permission_set.PowerUserAccess.arn
      principal_type     = "GROUP"
    },
    {
      file_name          = "ReadOnlyAccess_GROUP.txt"
      permission_set_arn = aws_ssoadmin_permission_set.ReadOnlyAccess.arn
      principal_type     = "GROUP"
    },
    {
      file_name          = "DeveloperAccess_GROUP.txt"
      permission_set_arn = aws_ssoadmin_permission_set.DeveloperAccess.arn
      principal_type     = "GROUP"
    },
  ]

  assignment_target_users = [
    {
      file_name          = "AdministratorAccess_USER.txt"
      permission_set_arn = aws_ssoadmin_permission_set.AdministratorAccess.arn
      principal_type     = "USER"
    },
    {
      file_name          = "PowerUserAccess_USER.txt"
      permission_set_arn = aws_ssoadmin_permission_set.PowerUserAccess.arn
      principal_type     = "USER"
    },
    {
      file_name          = "ReadOnlyAccess_USER.txt"
      permission_set_arn = aws_ssoadmin_permission_set.ReadOnlyAccess.arn
      principal_type     = "USER"
    },
    {
      file_name          = "DeveloperAccess_USER.txt"
      permission_set_arn = aws_ssoadmin_permission_set.DeveloperAccess.arn
      principal_type     = "USER"
    },
  ]
}
