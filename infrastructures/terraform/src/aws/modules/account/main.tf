terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

# AWSアカウントIDを取得するためのデータソース
data "aws_caller_identity" "current" {
  # provider = aws.custom
}
