
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

data "aws_wafv2_rule_group" "target_rule_group" {
  name  = var.rule_group_name
  scope = var.scope
}
