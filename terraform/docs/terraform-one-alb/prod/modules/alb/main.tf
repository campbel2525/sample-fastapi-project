data "aws_lb" "alb" {
  name = "${var.project_name}-${var.environment}-alb"
}
