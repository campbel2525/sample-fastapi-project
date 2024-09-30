terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

# roleの作成
resource "aws_iam_role" "default" {
  name               = "${var.base_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.role_type
      identifiers = [var.identifier]
    }
  }
}

# ポリシーの作成
resource "aws_iam_policy" "default" {
  name   = "${var.base_name}-policy"
  policy = var.policy_json
}

# roleとpolicyの紐付け
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}



# 使用方法1
# data "aws_iam_policy" "ec2_for_ssm" {
#   arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# module "ec2_for_ssm_role" {
#   source      = "../../../../../modules/iam_role"
#   name        = "ec2-for-ssm"
#   identifier  = "ec2.amazonaws.com"
#   policy_json = data.aws_iam_policy.ec2_for_ssm.policy
#   role_type   = "Service"
# }

# 使用方法2
# data "aws_iam_policy" "ec2_for_ssm" {
#   arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# data "aws_iam_policy_document" "ec2_for_ssm" {
#   source_policy_documents = [data.aws_iam_policy.ec2_for_ssm.policy]

#   statement {
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "ssm:*",
#     ]
#   }
# }

# module "ec2_for_ssm_role" {
#   source      = "../../../../../modules/iam_role"
#   name        = "ec2-for-ssm"
#   identifier  = "ec2.amazonaws.com"
#   policy_json = data.aws_iam_policy_document.ec2_for_ssm.json
#   role_type   = "Service"
# }
