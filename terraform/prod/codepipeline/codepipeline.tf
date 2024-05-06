# ---------------------------------------------
# codepipeline
# 注意 codepipeline->amplifyはデプロイができない
# ---------------------------------------------
resource "aws_codepipeline" "codepipeline" {
  name     = "codepipeline"
  role_arn = module.codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }

  # ---------------------------------------------
  # Sourceステージ (githubからソースコードを取得)
  # 下記の部分意味あるかわからない
  # 手動で連携する必要がある
  # ---------------------------------------------
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = 1
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codepipeline.arn
        FullRepositoryId = "${var.github_owner}/${var.target_repository}"
        BranchName       = var.target_branch
        # OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  # ---------------------------------------------
  # bildステージ (codebiuldを実行し、ECRにDockeイメージをpushする)
  # ---------------------------------------------
  stage {
    name = "Build"

    # admin-api
    action {
      name             = "Build_AdminApi"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact_AdminApi"]

      configuration = {
        ProjectName = aws_codebuild_project.admin_api.id
      }
    }

    # user-api
    action {
      name             = "Build_UserApi"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact_UserApi"]

      configuration = {
        ProjectName = aws_codebuild_project.user_api.id
      }
    }

    # admin-front
    action {
      name             = "Build_AdminFront"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact_AdminFront"]

      configuration = {
        ProjectName = aws_codebuild_project.admin_front.id
      }
    }

    # user-front
    action {
      name             = "Build_UserFront"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact_UserFront"]

      configuration = {
        ProjectName = aws_codebuild_project.user_front.id
      }
    }
  }

  # ---------------------------------------------
  # predeployステージ (マイグレーションを行う)
  # admin-apiのマイグレーションを実行する
  # ---------------------------------------------
  stage {
    name = "PreDeploy"

    action {
      name             = "Build_Migration_PreDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["PreDeployOutput_Migration"]

      configuration = {
        ProjectName = aws_codebuild_project.predploy.id
      }
    }
  }

  # ---------------------------------------------
  # deproyステージ (ECSへDockerイメージをデプロイする)
  # ---------------------------------------------
  stage {
    name = "Deploy"

    # admin-api
    action {
      name            = "Deploy_AdminApi"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["BuildArtifact_AdminApi"]

      configuration = {
        ClusterName = "${var.project_name}-${var.environment}-ecs-cluster"
        ServiceName = "${var.project_name}-${var.environment}-admin-api-app"
        # 以下のFilenameにprodなどにしなくていい？
        # buildspec-admin-api.ymlは環境ごとに依存せず共通で使用したいのでprodなどは入れたくない
        FileName = "imagedefinitions-admin-api.json"
      }
    }

    # user-api
    action {
      name            = "Deploy_UserApi"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["BuildArtifact_UserApi"]

      configuration = {
        ClusterName = "${var.project_name}-${var.environment}-ecs-cluster"
        ServiceName = "${var.project_name}-${var.environment}-user-api-app"
        # 以下のFilenameにprodなどにしなくていい？
        # buildspec-user-api.ymlは環境ごとに依存せず共通で使用したいのでprodなどは入れたくない
        FileName = "imagedefinitions-user-api.json"
      }
    }

    # admin-front
    action {
      name            = "Deploy_AdminFront"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["BuildArtifact_AdminFront"]

      configuration = {
        ClusterName = "${var.project_name}-${var.environment}-ecs-cluster"
        ServiceName = "${var.project_name}-${var.environment}-admin-front-app"
        # 以下のFilenameにprodなどにしなくていい？
        # buildspec-admin-front.ymlは環境ごとに依存せず共通で使用したいのでprodなどは入れたくない
        FileName = "imagedefinitions-admin-front.json"
      }
    }

    # user-front
    action {
      name            = "Deploy_UserFront"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["BuildArtifact_UserFront"]

      configuration = {
        ClusterName = "${var.project_name}-${var.environment}-ecs-cluster"
        ServiceName = "${var.project_name}-${var.environment}-user-front-app"
        # 以下のFilenameにprodなどにしなくていい？
        # buildspec-user-front.ymlは環境ごとに依存せず共通で使用したいのでprodなどは入れたくない
        FileName = "imagedefinitions-user-front.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "codepipeline" {
  name            = "codepipeline"
  target_pipeline = aws_codepipeline.codepipeline.name
  target_action   = "Source"
  authentication  = "GITHUB_HMAC"

  authentication_configuration {
    secret_token = var.aws_codepipeline_webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

resource "github_repository_webhook" "codepipeline" {
  repository = var.target_repository

  configuration {
    url          = aws_codepipeline_webhook.codepipeline.url
    secret       = var.github_repository_webhook_secret
    content_type = "json"
    insecure_ssl = false
  }

  events = ["push"]
}
