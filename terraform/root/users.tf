########################################
# User
########################################
resource "aws_identitystore_user" "this" {
  for_each = local.users

  display_name      = each.value
  identity_store_id = local.identity_store_id
  user_name         = each.value

  emails {
    primary = true
    type    = "work"
    value   = each.value
  }
  name {
    family_name = " "
    given_name  = " "
  }
}

########################################
# Users
########################################
locals {
  user_file = "../user/user.txt"
  # ファイルが存在しない、または読み込めない場合は空リストとする
  # Empty list if the file does not exist or cannot be read
  emails = (can(fileexists(local.user_file)) && fileexists(local.user_file)
  ? split("\n", trimspace(file(local.user_file))) : [])

  users = {
    for email in local.emails : regex("(^[^@]+)", email)[0] => email
  }
}

########################################
# dummy module
########################################
# tfaction等、diffベースでターゲットディレクトリを検出するCIツールに
# ../user 配下の.txtファイル変更を検知させるためのダミーmodule。
# Terraformの実行自体には影響しない。
#
# A dummy module so diff-based CI tools (e.g. tfaction) that resolve changed
# files to Terraform targets via module dependencies can detect changes under
# ../user (which contains only .txt files, not a Terraform module by itself).
# It has no effect on Terraform itself.
module "dummy_user" {
  source = "../user"
}
