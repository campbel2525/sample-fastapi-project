data "aws_security_group" "alb_sg" {
  tags = {
    Name    = "${var.project}-${var.environment}-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

data "aws_security_group" "ecs_only_from_alb_sg" {
  tags = {
    Name    = "${var.project}-${var.environment}-ecs-only-from-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

data "aws_security_group" "db_sg" {
  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

data "aws_security_group" "ec2_sg" {
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-sg"
    Project = var.project
    Env     = var.environment
  }
}

data "aws_security_group" "codebuild_sg" {
  tags = {
    Name    = "${var.project}-${var.environment}-codebuild-sg"
    Project = var.project
    Env     = var.environment
  }
}
