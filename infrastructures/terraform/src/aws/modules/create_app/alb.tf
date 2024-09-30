# ---------------------------------------------
# ALB
# ---------------------------------------------

resource "aws_lb" "alb_app" {
  name                       = "${var.target_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  idle_timeout               = 5
  enable_deletion_protection = false # 削除保護 - 本番ではtrueにする

  security_groups = [
    var.security_group_alb_sg_id
  ]

  subnets = [
    var.public_subnet_1a_id,
    var.public_subnet_1c_id
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }
}

# ---------------------------------------------
# Target Group
# ---------------------------------------------
resource "aws_lb_target_group" "alb_app_target_group" {
  name                 = "${var.target_name}-alb-tg"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  port                 = 8000
  protocol             = "HTTP"
  deregistration_delay = 10 # 登録解除の遅延時間

  tags = {
    Name = "${var.target_name}-alb-tg"
  }

  health_check {
    path                = var.health_check_path # ヘルスチェックで使用するパス
    healthy_threshold   = 2                     # 正常判定を行うまでのヘルスチェック実行回数
    unhealthy_threshold = 2                     # 異常判定を行うまでのヘルスチェック実行回数
    timeout             = 2                     # ヘルスチェックのタイムアウト時間（秒）
    interval            = 5                     # ヘルスチェックの実行間隔（秒）
    matcher             = "200"                 # 正常判定を行うために使用するHTTPステータスコード
    port                = "traffic-port"        # ヘルスチェックで使用するポート
    protocol            = "HTTP"                #  ヘルスチェック時に使用するプロトコル
  }
}

# ---------------------------------------------
# Listener
# ---------------------------------------------
resource "aws_lb_listener" "alb_app_listener_http" {
  load_balancer_arn = aws_lb.alb_app.arn
  port              = "80"
  protocol          = "HTTP"

  # 全てのリクエストをHTTPSにリダイレクト
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_listener" "alb_app_listener_https" {
  load_balancer_arn = aws_lb.alb_app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.tokyo_cert_arn

  # デフォルトアクションとしてターゲットグループにトラフィックを転送
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
  }
}

# ALBからECSへの振り分け設定
resource "aws_lb_listener_rule" "for_ecs_app" {
  listener_arn = aws_lb_listener.alb_app_listener_https.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
