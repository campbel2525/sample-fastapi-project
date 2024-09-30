# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "aws-admin"
}

provider "aws" {
  profile = "aws-prod"
  alias   = "aws_prod"
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
    key = "route53/campbel.love/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------
module "route53" {
  source = "../../../../modules/route53"
  domain = var.domain
}

module "admin_api_alb" {
  source   = "../../../../modules/alb"
  alb_name = "admin-api-alb"

  providers = {
    aws = aws.aws_prod
  }
}

module "admin_front_alb" {
  source   = "../../../../modules/alb"
  alb_name = "admin-front-alb"

  providers = {
    aws = aws.aws_prod
  }
}

module "user_api_alb" {
  source   = "../../../../modules/alb"
  alb_name = "user-api-alb"

  providers = {
    aws = aws.aws_prod
  }
}


module "user_front_alb" {
  source   = "../../../../modules/alb"
  alb_name = "user-front-alb"

  providers = {
    aws = aws.aws_prod
  }
}
