# ---------------------------------------------
# predeploy
# ---------------------------------------------
resource "aws_codebuild_project" "predploy" {
  name         = "predeploy"
  description  = "CodeBuild project for predeploy"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/buildspec-predeploy.yml"
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
      name  = "APP_NAME"
      value = "admin-api"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = module.current_account.account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }

  vpc_config {
    vpc_id = module.vpc.id

    subnets = [
      module.private_subnet_1a.id,
      module.private_subnet_1c.id,
    ]

    security_group_ids = [
      module.codebuild_security_group.id
    ]
  }
}

# ---------------------------------------------
# admin-api
# ---------------------------------------------
resource "aws_codebuild_project" "admin_api" {
  name         = "admin-api"
  description  = "CodeBuild project for admin-api"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/buildspec-api.yml"
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
      name  = "APP_NAME"
      value = "admin-api"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = module.current_account.account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }
}

# ---------------------------------------------
# admin-front
# ---------------------------------------------
resource "aws_codebuild_project" "admin_front" {
  name         = "admin-front"
  description  = "CodeBuild project for admin-front"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/buildspec-front.yml"
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
      name  = "APP_NAME"
      value = "admin-front"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = module.current_account.account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }
}


# ---------------------------------------------
# user-api
# ---------------------------------------------
resource "aws_codebuild_project" "user_api" {
  name         = "user-api"
  description  = "CodeBuild project for user-api"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/buildspec-api.yml"
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
      name  = "APP_NAME"
      value = "user-api"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = module.current_account.account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }
}

# ---------------------------------------------
# user-front
# ---------------------------------------------
resource "aws_codebuild_project" "user_front" {
  name         = "user-front"
  description  = "CodeBuild project for user-front"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "infrastructures/buildspecs/buildspec-front.yml"
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
      name  = "APP_NAME"
      value = "user-front"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = module.current_account.account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }
}
