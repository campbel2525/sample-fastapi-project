# ---------------------------------------------
# Route53
# ---------------------------------------------
# resource "aws_route53_zone" "route53_zone" {
#   name          = var.domain
#   force_destroy = false

#   tags = {
#     Name    = "${var.project}-${var.environment}-domain"
#     Project = var.project
#     Env     = var.environment
#   }
# }

resource "aws_route53_record" "route53_record" {
  # zone_id = aws_route53_zone.route53_zone.id # ホストゾーンID
  zone_id = var.aws_route53_record_zone_id # すでにreoute53にレコードが存在するので、idはすでに決まっている
  name    = var.admin_api_domain           # レコード名
  type    = "A"                            # レコードタイプ

  alias {
    name                   = aws_lb.alb_app.dns_name
    zone_id                = aws_lb.alb_app.zone_id
    evaluate_target_health = true
  }
}

# albの場合
# name = <ADDRESS>.dns_name
# zone_id = <ADDRESS>.zone_id

# albの場合
# name = <ADDRESS>.domain_name
# zone_id = <ADDRESS>.hosted_zone_id
