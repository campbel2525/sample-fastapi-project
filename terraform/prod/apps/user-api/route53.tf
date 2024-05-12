# ---------------------------------------------
# Route53
# ---------------------------------------------
resource "aws_route53_record" "route53_record" {
  # zone_id = aws_route53_zone.route53_zone.id # ホストゾーンID
  zone_id = var.aws_route53_record_zone_id # すでにreoute53にレコードが存在するので、idはすでに決まっている
  name    = var.user_api_domain            # レコード名
  type    = "A"                            # レコードタイプ

  alias {
    name                   = aws_lb.alb_app.dns_name
    zone_id                = aws_lb.alb_app.zone_id
    evaluate_target_health = true
  }
}
