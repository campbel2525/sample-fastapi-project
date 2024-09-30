terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

data "aws_dx_connection" "target" {
  name = var.dx_connection_name
}
