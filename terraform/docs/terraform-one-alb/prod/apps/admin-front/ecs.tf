# タスク定義
resource "aws_ecs_task_definition" "ecs_app" {
  family                   = "${var.project_name}-${var.environment}-admin-front" # タスク定義名のプレフィックス
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_execution_role.iam_role_arn
  task_role_arn            = module.ecs_task_role.iam_role_arn
  container_definitions    = <<EOF
    [
      {
        "name": "${var.project_name}-${var.environment}-admin-front-app",
        "image": "public.ecr.aws/docker/library/node:18-bullseye",
        "essential": true,
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-region": "${var.aws_region}",
            "awslogs-group": "/aws/ecs/${var.project_name}/${var.environment}/admin-front-app",
            "awslogs-stream-prefix": "${var.project_name}-${var.environment}-admin-front-app"
          }
        },
        "portMappings": [
          {
            "hostPort": 3000,
            "protocol": "tcp",
            "containerPort": 3000
          }
        ],
        "environment": [],
        "secrets": [
          {
            "name": "APP_ENV_VALUES",
            "valueFrom": "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/ecs/${var.project_name}/${var.environment}/admin-front/.env"
          }
        ]
      }
    ]
  EOF
}

resource "aws_ecs_service" "ecs_app" {
  name                              = "${var.project_name}-${var.environment}-admin-front-app"
  cluster                           = "arn:aws:ecs:ap-northeast-1:${var.aws_account_id}:cluster/${var.project_name}-${var.environment}-ecs-cluster"
  task_definition                   = aws_ecs_task_definition.ecs_app.arn
  desired_count                     = 2 # タスクが維持するタスク数(最低2以上としておく)
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0" # LATESTは最新のバージョンでないこともあるので、明示的に記載する
  health_check_grace_period_seconds = 60      # ヘルスチェック猶予期間。十分な猶予期間がないとヘルスチェックに引っかかり、タスクの起動と終了が無限に続いてしまうことがある
  enable_execute_command            = true    # コンテナに入るための設定

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.app_sg.id]

    subnets = [
      module.network.private_subnet_1a_id,
      module.network.private_subnet_1c_id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
    container_name   = "${var.project_name}-${var.environment}-admin-front-app"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [
    aws_ecs_task_definition.ecs_app,
    aws_lb_target_group.alb_app_target_group,
    aws_security_group.app_sg,
    aws_security_group_rule.ecs_only_from_alb_in_http,
    aws_security_group_rule.ecs_only_from_alb_out_all,
  ]
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${var.project_name}/${var.environment}/admin-front-app"
  retention_in_days = 30
}
