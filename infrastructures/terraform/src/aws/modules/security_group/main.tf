


module "vpc" {
  source   = "../vpc"
  vpc_name = var.vpc_name
}

data "aws_security_group" "sg" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.id]
  }

  filter {
    name   = "group-name"
    values = [var.security_group_name]
  }
}
