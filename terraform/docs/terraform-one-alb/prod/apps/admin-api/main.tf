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
    bucket  = "terraform-project-sample-prod-1"
    key     = "apps/admin-api/terraform.tfstate"
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
# Modules
# ---------------------------------------------
module "network" {
  source       = "../../modules/network"
  project_name = var.project_name
  environment  = var.environment
}

module "security_group" {
  source       = "../../modules/security_group"
  project_name = var.project_name
  environment  = var.environment
}

module "alb" {
  source       = "../../modules/alb"
  project_name = var.project_name
  environment  = var.environment
}
