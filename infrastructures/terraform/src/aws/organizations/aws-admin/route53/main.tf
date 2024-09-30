# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "aws-admin"
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
    key = "route53/terraform.tfstate"
  }
}
