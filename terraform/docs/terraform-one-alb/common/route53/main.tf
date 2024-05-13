# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "terraform-campbel2525"
    key     = "acm/campbel.jp/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "campbel2525"
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

provider "aws" {
  alias      = "virginia"
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "aws_access_key_id" {
  type = string
}
variable "aws_secret_access_key" {
  type = string
}
variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "domain" {
  type = string
}

# すでにroute53にレコードがある場合
# variable "aws_route53_record_zone_id" {
#   type = string
# }
