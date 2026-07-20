provider "aws" {
  region = local.aws_region
}

terraform {
  required_version = ">=1.8.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.55.0"
    }
  }

  # このサンプルでは backend を明示していません（local backend で動作確認する想定）。
  # 実運用では以下のように S3 backend を指定してください。
  #
  # This sample does not declare a backend (intended to be validated with the local backend).
  # For real use, specify an S3 backend as shown below.
  # backend "s3" {
  #   bucket = "example-idc-terraform-state-000000000000"
  #   key    = "idc.tfstate"
  #   region = "ap-northeast-1"
  # }
}
