# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = var.aws_default_profile
}

provider "aws" {
  profile = "aws-admin"
  alias   = "aws_admin"
}

# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }

  backend "s3" {
    key = "acm/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------

module "route53" {
  source = "../../../modules/route53"
  domain = var.domain

  providers = {
    aws = aws.aws_admin
  }
}
