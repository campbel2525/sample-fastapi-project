# ---------------------------------------------
# predeploy
# ---------------------------------------------
resource "aws_codebuild_project" "predploy" {
  name         = "${var.project_name}-${var.environment}-predeploy"
  description  = "CodeBuild project for predeploy"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-predeploy.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD" # AWS CodeBuildが提供するDockerイメージをプルする際の資格情報を使用します(or SERVICE_ROLE)

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name  = "APP_NAME"
      value = "admin-api"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
  }

  vpc_config {
    vpc_id = module.network.vpc_id

    subnets = [
      module.network.private_subnet_1a_id,
      module.network.private_subnet_1c_id,
    ]

    security_group_ids = [
      module.security_group.codebuild_sg_id
    ]
  }
}

# ---------------------------------------------
# admin-api
# ---------------------------------------------
resource "aws_codebuild_project" "admin_api" {
  name         = "${var.project_name}-${var.environment}-admin-api"
  description  = "CodeBuild project for admin-api"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-api.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD" # AWS CodeBuildが提供するDockerイメージをプルする際の資格情報を使用します(or SERVICE_ROLE)

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name  = "APP_NAME"
      value = "admin-api"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
  }
}

# ---------------------------------------------
# admin-front
# ---------------------------------------------
resource "aws_codebuild_project" "admin_front" {
  name         = "${var.project_name}-${var.environment}-admin-front"
  description  = "CodeBuild project for admin-front"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-front.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD" # AWS CodeBuildが提供するDockerイメージをプルする際の資格情報を使用します(or SERVICE_ROLE)

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name  = "APP_NAME"
      value = "admin-front"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
  }
}


# ---------------------------------------------
# user-api
# ---------------------------------------------
resource "aws_codebuild_project" "user_api" {
  name         = "${var.project_name}-${var.environment}-user-api"
  description  = "CodeBuild project for user-api"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-api.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD" # AWS CodeBuildが提供するDockerイメージをプルする際の資格情報を使用します(or SERVICE_ROLE)

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name  = "APP_NAME"
      value = "user-api"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
  }
}

# ---------------------------------------------
# user-front
# ---------------------------------------------
resource "aws_codebuild_project" "user_front" {
  name         = "${var.project_name}-${var.environment}-user-front"
  description  = "CodeBuild project for user-front"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-front.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD" # AWS CodeBuildが提供するDockerイメージをプルする際の資格情報を使用します(or SERVICE_ROLE)

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name  = "APP_NAME"
      value = "user-front"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
  }
}
