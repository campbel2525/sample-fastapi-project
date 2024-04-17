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
    # github = {
    #   source  = "integrations/github"
    #   version = "~> 4.0"
    # }
  }
  backend "s3" {
    bucket  = "terraform-project-sample-prod-1"
    key     = "app/common/aws_ecs_cluster/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "campbel2525"
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  alias      = "virginia"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# provider "github" {
#   # base_url = "https://ghe.company.com/"
#   # owner = "my-org"
#   # organization = "campbel2525"
#   owner = var.github_owner
#   token = var.github_token
# }

# ---------------------------------------------
# Modules
# ---------------------------------------------

module "network" {
  source      = "../../../modules/output/network"
  project     = var.project
  environment = var.environment
}

module "security_group" {
  source      = "../../../modules/output/security_group"
  project     = var.project
  environment = var.environment
}
