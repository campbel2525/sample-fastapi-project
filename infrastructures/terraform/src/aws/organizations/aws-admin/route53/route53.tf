# ---------------------------------------------
# route53
# ---------------------------------------------
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false

  tags = {
    Name    = "${var.domain}-route53-zone"
    Project = "${var.domain}"
  }
}
