data "aws_security_group" "alb_sg" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-alb-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

# data "aws_security_group" "ecs_only_from_alb_sg" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-ecs-only-from-alb-sg"
#     Project = var.project_name
#     Env     = var.environment
#   }
# }

data "aws_security_group" "db_sg" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-db-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

data "aws_security_group" "ec2_sg" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-ec2-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

data "aws_security_group" "codebuild_sg" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-codebuild-sg"
    Project = var.project_name
    Env     = var.environment
  }
}
