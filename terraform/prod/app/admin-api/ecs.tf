
# タスク定義
resource "aws_ecs_task_definition" "ecs_app" {
  family                   = "${var.project}-${var.environment}-${var.admin_api_name}-ecs-task-definition" # タスク定義名のプレフィックス
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = <<EOF
    [
      {
        "name": "app",
        "image": "python:3.10",
        "essential": true,
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "${var.project}-${var.environment}-${var.admin_api_name}-app",
            "awslogs-group": "/ecs/${var.project}/${var.environment}/${var.admin_api_name}/app"
          }
        },
        "portMappings": [
          {
            "hostPort": 8000,
            "protocol": "tcp",
            "containerPort": 8000
          }
        ],
        "environment": [
          {
            "name": "APP_ENV",
            "value": "prod"
          }
        ],
        "secrets": [
          {
            "name": "APP_ENV_VALUES",
            "valueFrom": "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/ecs/${var.project}/${var.environment}/${var.admin_api_name}/.env"
          }
        ]
      }
    ]
  EOF
}

resource "aws_ecs_service" "ecs_app" {
  name                              = "${var.project}-${var.environment}-ecs-service-${var.admin_api_name}"
  cluster                           = "arn:aws:ecs:ap-northeast-1:${var.aws_account_id}:cluster/${var.project}-${var.environment}-ecs-cluster"
  task_definition                   = aws_ecs_task_definition.ecs_app.arn
  desired_count                     = 2 # タスクが維持するタスク数(最低2以上としておく)
  launch_type                       = "FARGATE"
  platform_version                  = "1.3.0" # LATESTは最新のバージョンでないこともあるので、明示的に記載する
  health_check_grace_period_seconds = 60      # ヘルスチェック猶予期間。十分な猶予期間がないとヘルスチェックに引っかかり、タスクの起動と終了が無限に続いてしまうことがある

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.security_group.ecs_only_from_alb_sg_id]

    subnets = [
      module.network.private_subnet_1a_id,
      module.network.private_subnet_1c_id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
    container_name   = "app"
    container_port   = 8000
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project}/${var.environment}/${var.admin_api_name}/app"
  retention_in_days = 30
}
