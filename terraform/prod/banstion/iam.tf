data "aws_iam_policy" "ec2_for_ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_for_ssm" {
  source_policy_documents = [data.aws_iam_policy.ec2_for_ssm.policy]

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      # "ssm:GetParameter",
      # "ssm:GetParameters",
      # "ssm:GetParametersByPath",
      "kms:Decrypt",
      # "rds:*",
      "ssm:StartSession",
      "ssm:*",
    ]
  }
}

module "ec2_for_ssm_role" {
  source     = "../modules/iam_role"
  name       = "${var.project_name}-${var.environment}-ec2-for-ssm"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.ec2_for_ssm.json
}
