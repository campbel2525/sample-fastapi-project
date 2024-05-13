# ---------------------------------------------
# ALB
# ---------------------------------------------
resource "aws_lb" "alb_app" {
  name                       = "${var.project_name}-${var.environment}-alb"
  internal                   = false
  load_balancer_type         = "application"
  idle_timeout               = 5
  enable_deletion_protection = false # 削除保護 - 本番ではtrueにする

  security_groups = [
    module.security_group.alb_sg_id
  ]

  subnets = [
    module.network.public_subnet_1a_id,
    module.network.public_subnet_1c_id
  ]

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    enabled = true
  }
}


resource "aws_lb_listener" "alb_app_listener_http" {
  load_balancer_arn = aws_lb.alb_app.arn
  port              = "80"
  protocol          = "HTTP"

  # httpsに強制リダイレクトしているから必要なさそうに思うが、default_actionは必須項目ので必要
  # ターゲットを使用する場合
  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.alb_app_target_group.arn
  # }
  # 直接文字を表示する場合(全てのルーティングに合わない場合)
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "alb_app_listener_https" {
  load_balancer_arn = aws_lb.alb_app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.tokyo_cert_arn

  # certificate_arn   = var.aws_tokyo_cert_arn #

  # deafult actionターゲットを使用する場合
  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.alb_app_target_group.arn
  # }
  # 直接文字を表示する場合(全てのルーティングに合わない場合)
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTPS』です"
      status_code  = "200"
    }
  }
}
