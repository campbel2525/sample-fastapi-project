# admin-api
resource "aws_ssm_parameter" "admin_api_env" {
  name  = "/ecs/app/admin-api/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "admin-api-ssm-parameter"
  }

  tier = "Standard"
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# user-api
resource "aws_ssm_parameter" "user_api_env" {
  name  = "/ecs/app/user-api/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "user-api-ssm-parameter"
  }

  tier = "Standard"
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}


# admin-front
resource "aws_ssm_parameter" "admin_front_env" {
  name  = "/ecs/app/admin-front/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "admin-front-ssm-parameter"
  }

  tier = "Standard"
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# admin-front
resource "aws_ssm_parameter" "admin_front_env_public" {
  name  = "/ecs/app/admin-front/.env.public"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "admin-front-ssm-parameter"
  }

  tier = "Standard"
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}


# user-front
resource "aws_ssm_parameter" "user_front_env" {
  name  = "/ecs/app/user-front/.env"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "user-front-ssm-parameter"
  }

  tier = "Standard"
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# user-front
resource "aws_ssm_parameter" "user_front_env_public" {
  name  = "/ecs/app/user-front/.env.public"
  type  = "SecureString"
  value = "default"

  # 値を上書きしない
  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Name = "user-front-ssm-parameter"
  }

  tier = "Standard"
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}
