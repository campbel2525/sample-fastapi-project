# ---------------------------------------------
# Certificate
# ---------------------------------------------
# for tokyo region
resource "aws_acm_certificate" "tokyo_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-wildcard-sslcert-tokyo"
    Project = var.project
    # Env     = var.environment
  }

  lifecycle {
    create_before_destroy = true # elbで証明書を利用している場合、trueの指定が推奨
  }

  # すでに存在しているroute53を使用するのでコメントアウトする
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}

resource "aws_route53_record" "route53_acm_dns_resolve" {
  for_each = {
    for dvo in aws_acm_certificate.tokyo_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.route53_zone.zone_id
  # zone_id = var.aws_route53_record_zone_id # すでにreoute53にレコードが存在するので、idはすでに決まっている
  name    = each.value.name
  type    = each.value.type
  ttl     = 600
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn = aws_acm_certificate.tokyo_cert.arn
  # route53レコードに登録した検証用CNAMEレコードのFQDN
  validation_record_fqdns = [for record in aws_route53_record.route53_acm_dns_resolve : record.fqdn]
}

# for virginia region
resource "aws_acm_certificate" "virginia_cert" {
  provider = aws.virginia

  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-wildcard-sslcert-virginia"
    Project = var.project
    # Env     = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  # すでに存在しているroute53を使用するのでコメントアウトする
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}
