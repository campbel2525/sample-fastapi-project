# ---------------------------------------------
# codebuild
# ---------------------------------------------
data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      # "s3:PutObject",
      # "s3:GetObject",
      # "s3:GetObjectVersion",
      # "logs:CreateLogGroup",
      # "logs:CreateLogStream",
      # "logs:PutLogEvents",
      # "ecr:GetAuthorizationToken",
      # "ecr:BatchCheckLayerAvailability",
      # "ecr:GetDownloadUrlForLayer",
      # "ecr:GetRepositoryPolicy",
      # "ecr:DescribeRepositories",
      # "ecr:ListImages",
      # "ecr:DescribeImages",
      # "ecr:BatchGetImage",
      # "ecr:InitiateLayerUpload",
      # "ecr:UploadLayerPart",
      # "ecr:CompleteLayerUpload",
      # "ecr:PutImage",
      # "ecr:CreateRepository",

      "ecr:*",

      "s3:*",
      "s3-object-lambda:*",
      "autoscaling:Describe*",
      "cloudwatch:*",
      "logs:*",
      "sns:*",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "cloudwatch:PutMetricData",
      "ds:CreateComputer",
      "ds:DescribeDirectories",
      "ec2:DescribeInstanceStatus",
      "logs:*",
      "ssm:*",
      "ec2messages:*",
      "iam:DeleteServiceLinkedRole",
      "iam:GetServiceLinkedRoleDeletionStatus",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      # "codebuild:CreateReportGroup",
      # "codebuild:CreateReport",
      # "codebuild:UpdateReport",
      # "codebuild:BatchPutTestCases",
      # "codebuild:BatchPutCodeCoverages"
      "codebuild:StartBuild", # "codebuild:StartBuild",は先に持ってくる
      "codebuild:*",

      # "ec2:CreateNetworkInterface",
      # "ec2:DescribeDhcpOptions",
      # "ec2:DescribeNetworkInterfaces",
      # "ec2:DeleteNetworkInterface",
      # "ec2:DescribeSubnets",
      # "ec2:DescribeSecurityGroups",
      # "ec2:DescribeVpcs",
      # "ec2:CreateNetworkInterfacePermission",

      "ec2:*",
    ]
  }
}

module "codebuild_role" {
  source      = "../../../modules/iam_role"
  base_name   = "codebuild"
  identifier  = "codebuild.amazonaws.com"
  policy_json = data.aws_iam_policy_document.codebuild.json
  role_type   = "Service"
}


# ---------------------------------------------
# codepipeline
# ---------------------------------------------
data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      # "s3:PutObject",
      # "s3:GetObject",
      # "s3:GetObjectVersion",
      # "s3:GetBucketVersioning",
      # "codebuild:BatchGetBuilds",
      # "codebuild:StartBuild",
      # "ecs:DescribeServices",
      # "ecs:DescribeTaskDefinition",
      # "ecs:DescribeTasks",
      # "ecs:ListTasks",
      # "ecs:RegisterTaskDefinition",
      # "ecs:UpdateService",
      # "iam:PassRole",
      # "codestar:*",

      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
      # "codedeploy:CreateDeployment",
      # "codedeploy:GetApplication",
      # "codedeploy:GetApplicationRevision",
      # "codedeploy:GetDeployment",
      # "codedeploy:GetDeploymentConfig",
      # "codedeploy:RegisterApplicationRevision",
      "codestar-connections:UseConnection",
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:RegisterTaskDefinition",
      "ecs:*",
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
      "opsworks:CreateDeployment",
      "opsworks:DescribeApps",
      "opsworks:DescribeCommands",
      "opsworks:DescribeDeployments",
      "opsworks:DescribeInstances",
      "opsworks:DescribeStacks",
      "opsworks:UpdateApp",
      "opsworks:UpdateStack",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate",
      "devicefarm:ListProjects",
      "devicefarm:ListDevicePools",
      "devicefarm:GetRun",
      "devicefarm:GetUpload",
      "devicefarm:CreateUpload",
      "devicefarm:ScheduleRun",
      "servicecatalog:ListProvisioningArtifacts",
      "servicecatalog:CreateProvisioningArtifact",
      "servicecatalog:DescribeProvisioningArtifact",
      "servicecatalog:DeleteProvisioningArtifact",
      "servicecatalog:UpdateProduct",
      "cloudformation:ValidateTemplate",
      "ecr:DescribeImages",
      "states:DescribeExecution",
      "states:DescribeStateMachine",
      "states:StartExecution",
      "appconfig:StartDeployment",
      "appconfig:StopDeployment",
      "appconfig:GetDeployment",
      "codebuild:*",
      "codedeploy:*",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:PassRole"
    ]

    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"

      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

module "codepipeline_role" {
  source      = "../../../modules/iam_role"
  base_name   = "codepipeline"
  identifier  = "codepipeline.amazonaws.com"
  policy_json = data.aws_iam_policy_document.codepipeline.json
  role_type   = "Service"
}
