# ---------------------------------------------
# Certificate
# ---------------------------------------------
# for tokyo region
resource "aws_acm_certificate" "tokyo_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name = "wildcard-sslcert-tokyo"
  }

  lifecycle {
    create_before_destroy = true # elbで証明書を利用している場合、trueの指定が推奨
  }
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.tokyo_cert.arn
  validation_record_fqdns = [for dvo in aws_acm_certificate.tokyo_cert.domain_validation_options : dvo.resource_record_name]
}

# # for virginia region
# resource "aws_acm_certificate" "virginia_cert" {
#   provider = aws.virginia

#   domain_name       = "*.${var.domain}"
#   validation_method = "DNS"

#   tags = {
#     Name = "wildcard-sslcert-virginia"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# adminのroute53にacmのvalidationレコードを使用
resource "aws_route53_record" "route53_acm_dns_resolve" {
  provider = aws.aws_admin

  for_each = {
    for dvo in aws_acm_certificate.tokyo_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = module.route53.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  records         = [each.value.record]
}
