# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = var.aws_default_profile
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
    key = "rds/db1/terraform.tfstate"
  }
}


# ---------------------------------------------
# Modules
# ---------------------------------------------
module "private_subnet_1a" {
  source      = "../../../../modules/subnet"
  subnet_name = "private-subnet-1a"
}

module "private_subnet_1c" {
  source      = "../../../../modules/subnet"
  subnet_name = "private-subnet-1c"
}

module "db_security_group" {
  source              = "../../../../modules/security_group"
  vpc_name            = "vpc"
  security_group_name = "db-sg"
}
