# admin-api
resource "aws_ssm_parameter" "admin_api_env" {
  name  = "/ecs/${var.project_name}/${var.environment}/admin-api/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-admin-api-ssm-parameter"
    Project = var.project_name
    Env     = var.environment
  }

  overwrite = true
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# user-api
resource "aws_ssm_parameter" "user_api_env" {
  name  = "/ecs/${var.project_name}/${var.environment}/user-api/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-user-api-ssm-parameter"
    Project = var.project_name
    Env     = var.environment
  }

  overwrite = true
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}


# admin-front
resource "aws_ssm_parameter" "admin_front_env" {
  name  = "/ecs/${var.project_name}/${var.environment}/admin-front/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-admin-front-ssm-parameter"
    Project = var.project_name
    Env     = var.environment
  }

  overwrite = true
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# admin-front
resource "aws_ssm_parameter" "admin_front_env_public" {
  name  = "/ecs/${var.project_name}/${var.environment}/admin-front/.env.public"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-admin-front-ssm-parameter"
    Project = var.project_name
    Env     = var.environment
  }

  overwrite = true
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}


# user-front
resource "aws_ssm_parameter" "user_front_env" {
  name  = "/ecs/${var.project_name}/${var.environment}/user-front/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-user-front-ssm-parameter"
    Project = var.project_name
    Env     = var.environment
  }

  overwrite = true
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# user-front
resource "aws_ssm_parameter" "user_front_env_public" {
  name  = "/ecs/${var.project_name}/${var.environment}/user-front/.env.public"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-user-front-ssm-parameter"
    Project = var.project_name
    Env     = var.environment
  }

  overwrite = true
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}
