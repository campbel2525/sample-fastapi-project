# ---------------------------------------------
# route53
# ---------------------------------------------
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false

  tags = {
    Name    = "${var.project_name}-route53-zone"
    Project = var.project_name
    # Env     = var.environment
  }
}
