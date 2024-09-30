terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

data "aws_lb" "external_alb" {
  name = var.alb_name
}
