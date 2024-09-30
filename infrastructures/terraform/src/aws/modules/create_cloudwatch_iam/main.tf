terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

module "current_account" {
  source = "../account"
}

module "cloudwatch_cross_account_role" {
  source     = "../iam_role"
  base_name  = var.base_name
  identifier = "arn:aws:iam::${var.target_account_id}:root"
  role_type  = "AWS"

  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups"
      ],
      Resource = [
        "arn:aws:logs:${var.aws_region}:${module.current_account.account_id}:log-group:${var.log_group_name}"
      ]
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "arn:aws:iam::${module.current_account.account_id}:role/${var.base_name}-role"
    }]
  })
}
