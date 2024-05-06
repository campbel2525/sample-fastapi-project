# ---------------------------------------------
# セキュリティグループ
# ecs - albからのみ受け付ける
# ---------------------------------------------
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-${var.environment}-admin-api-sg"
  description = "ecs role security group"
  vpc_id      = module.network.vpc_id

  tags = {
    Name    = "${var.project_name}-${var.environment}-admin-api-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "ecs_only_from_alb_in_http" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8000
  to_port                  = 8000
  source_security_group_id = module.network.alb_sg_id
}

resource "aws_security_group_rule" "ecs_only_from_alb_out_all" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "db_in_tcp3306_from_ecs_only_from_alb_sg" {
  security_group_id        = module.security_group.db_sg_id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app_sg.id
}
