# このファイルはフレームワーク(idc-terraform-framework)のvariables.tfと同名だが、
# 本リポジトリはサンプルのため identity_store_id / aws_region を variable にせず
# locals にハードコードしている。そのため variable ブロックは含まれない。
data "aws_ssoadmin_instances" "instance" {}

locals {
  # サンプルのため Identity Store ID は架空値をハードコードしている
  identity_store_id = "d-0000000000"

  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]

  assignment_file_path = "../assignment"
  # assignment配下のフォルダ(AWSアカウントID)を列挙
  assignment_target_aws_accounts = distinct([
    for file in fileset(local.assignment_file_path, "*/*.txt") : dirname(file)
  ])

  membership_file_path = "../membership"
}

locals {
  # assignment_targets の定義
  # 利用するPermissionSetを増やす場合は、file_name / permission_set_arn / principal_type（"GROUP" または "USER"）のマッピングを追加する
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
