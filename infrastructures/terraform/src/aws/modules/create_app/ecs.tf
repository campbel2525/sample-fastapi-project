# タスク定義
resource "aws_ecs_task_definition" "ecs_app" {
  family                   = var.target_name # タスク定義名のプレフィックス
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_execution_role.iam_role_arn
  task_role_arn            = module.ecs_task_role.iam_role_arn
  container_definitions    = var.container_definitions
}

resource "aws_ecs_service" "ecs_app" {
  name                              = "${var.target_name}-app"
  cluster                           = "arn:aws:ecs:${var.aws_region}:${var.account_id}:cluster/ecs-cluster"
  task_definition                   = aws_ecs_task_definition.ecs_app.arn
  desired_count                     = 2 # タスクが維持するタスク数(最低2以上としておく)
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0" # LATESTは最新のバージョンでないこともあるので、明示的に記載する
  health_check_grace_period_seconds = 60      # ヘルスチェック猶予期間。十分な猶予期間がないとヘルスチェックに引っかかり、タスクの起動と終了が無限に続いてしまうことがある
  enable_execute_command            = true    # コンテナに入るための設定

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.security_group_ecs_app_sg_id]

    subnets = [
      var.private_subnet_1a_id,
      var.private_subnet_1c_id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
    container_name   = "${var.target_name}-app"
    container_port   = 8000
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [
    aws_ecs_task_definition.ecs_app,
    aws_lb_target_group.alb_app_target_group,
  ]
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${var.target_name}-app"
  retention_in_days = 30
}
