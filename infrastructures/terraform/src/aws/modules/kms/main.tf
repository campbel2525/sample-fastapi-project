terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

data "aws_kms_alias" "this" {
  name = "alias/${var.alias_name}"
}
