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
    key = "app/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------
module "vpc" {
  source   = "../../../modules/vpc"
  vpc_name = "vpc"
}

module "public_subnet_1a" {
  source      = "../../../modules/subnet"
  subnet_name = "public-subnet-1a"
}

module "public_subnet_1c" {
  source      = "../../../modules/subnet"
  subnet_name = "public-subnet-1c"
}

module "private_subnet_1a" {
  source      = "../../../modules/subnet"
  subnet_name = "private-subnet-1a"
}

module "private_subnet_1c" {
  source      = "../../../modules/subnet"
  subnet_name = "private-subnet-1c"
}

module "alb_security_group" {
  source              = "../../../modules/security_group"
  vpc_name            = "vpc"
  security_group_name = "alb-sg"
}

module "ecs_app_security_group" {
  source              = "../../../modules/security_group"
  vpc_name            = "vpc"
  security_group_name = "ecs-app-sg"
}

module "current_account" {
  source = "../../../modules/account"
}
