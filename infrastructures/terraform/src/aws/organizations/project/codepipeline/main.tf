# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = var.aws_default_profile
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
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

    github = {
      source  = "integrations/github"
      version = "~> 5.5"
    }
  }

  backend "s3" {
    key = "codepipeline/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------
module "vpc" {
  source   = "../../../modules/vpc"
  vpc_name = "vpc"
}

module "private_subnet_1a" {
  source      = "../../../modules/subnet"
  subnet_name = "private-subnet-1a"
}

module "private_subnet_1c" {
  source      = "../../../modules/subnet"
  subnet_name = "private-subnet-1c"
}

module "codebuild_security_group" {
  source              = "../../../modules/security_group"
  vpc_name            = "vpc"
  security_group_name = "codebuild-sg"
}

module "current_account" {
  source = "../../../modules/account"
}




resource "random_string" "artifact_bucket" {
  length  = 16
  upper   = false
  special = false
}
