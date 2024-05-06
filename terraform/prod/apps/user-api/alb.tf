
# ---------------------------------------------
# target group
# ---------------------------------------------
resource "aws_lb_target_group" "alb_app_target_group" {
  name                 = "${var.project_name}-${var.environment}-alb-user-api-tg"
  target_type          = "ip"
  vpc_id               = module.network.vpc_id
  port                 = 8001
  protocol             = "HTTP"
  deregistration_delay = 10 # 登録解除の待機時間

  tags = {
    Name    = "${var.project_name}-${var.environment}-alb-user-api-tg"
    Project = var.project_name
    Env     = var.environment
  }

  health_check {
    path                = "/hc"          # ヘルスチェックで使用するパス
    healthy_threshold   = 2              # 正常判定を行うまでのヘルスチェック実行回数
    unhealthy_threshold = 2              # 異常判定を行うまでのヘルスチェック実行回数
    timeout             = 2              # ヘルスチェックのタイムアウト時間（秒）
    interval            = 5              # ヘルスチェックの実行間隔（秒）
    matcher             = "200"          # 正常判定を行うために使用するHTTPステータスコード
    port                = "traffic-port" # ヘルスチェックで使用するポート
    protocol            = "HTTP"         #  ヘルスチェック時に使用するプロトコル
  }

  # depends_on = [aws_lb.alb_app]
}


# ---------------------------------------------
# リスナールール
# apiに振り分ける設定
# ---------------------------------------------
resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = var.aws_lb_listener_http_arn
  priority     = 3
  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }

  condition {
    host_header {
      values = [var.user_api_domain]
    }
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-user-api-http"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_lb_listener_rule" "for_ecs_app" {
  listener_arn = var.aws_lb_listener_https_arn
  priority     = 103

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
  }

  condition {
    host_header {
      values = [var.user_api_domain]
    }
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-user-api-https"
    Project = var.project_name
    Env     = var.environment
  }
}
