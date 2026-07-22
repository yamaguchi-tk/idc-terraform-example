# tfaction等、diffベースでターゲットディレクトリを検出するCIツールに
# ../assignment/<account_id> 配下の.txtファイル変更を検知させるためのダミーmodule群。
# accountディレクトリを追加/削除した場合は、ここにも対応するmodule blockを追加/削除すること。
# Terraformの実行自体には影響しない。
#
# Dummy modules so diff-based CI tools (e.g. tfaction) that resolve changed
# files to Terraform targets via module dependencies can detect changes under
# ../assignment/<account_id> (which contains only .txt files, not a Terraform
# module by itself). When you add/remove an account directory, add/remove the
# corresponding module block here too. This has no effect on Terraform itself.

module "dummy_111111111111" {
  source = "../assignment/111111111111"
}

module "dummy_222222222222" {
  source = "../assignment/222222222222"
}

module "dummy_333333333333" {
  source = "../assignment/333333333333"
}
