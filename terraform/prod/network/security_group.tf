# ---------------------------------------------
# alb_sg
# ---------------------------------------------

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "alb front role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-alb-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "alb_sg_in_http" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_sg_in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_out_all" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# db_sg
# ---------------------------------------------
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-db-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

# codebuild->db
resource "aws_security_group_rule" "db_in_tcp3306_from_codebuild_sg" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.codebuild_sg.id
}

# ec2->db
resource "aws_security_group_rule" "db_in_tcp3306_from_ec2_sg" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "db_out_all" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# ec2_sg
# ---------------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-ec2-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "ec2_out_all" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


# ---------------------------------------------
# codebuild_sg
# ---------------------------------------------
resource "aws_security_group" "codebuild_sg" {
  name        = "${var.project_name}-${var.environment}-codebuild-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-codebuild-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "ecodebuild_sg_out_all" {
  security_group_id = aws_security_group.codebuild_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# ecs
# ---------------------------------------------
resource "aws_security_group" "ecs_app_sg" {
  name        = "${var.project_name}-${var.environment}-ecs-app-sg"
  description = "ecs role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project_name}-${var.environment}-ecs-app-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "ecs_app_in_http" {
  security_group_id        = aws_security_group.ecs_app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8000
  to_port                  = 8000
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "ecs_app_out_all" {
  security_group_id = aws_security_group.ecs_app_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
