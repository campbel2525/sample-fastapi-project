output "alb_sg_id" {
  value       = data.aws_security_group.alb_sg.id
  description = "The ID of the Security Group."
}

output "ecs_only_from_alb_sg_id" {
  value       = data.aws_security_group.ecs_only_from_alb_sg.id
  description = "The ID of the Security Group."
}

output "db_sg_id" {
  value       = data.aws_security_group.db_sg.id
  description = "The ID of the Security Group."
}

output "ec2_sg_id" {
  value       = data.aws_security_group.ec2_sg.id
  description = "The ID of the Security Group."
}

output "codebuild_sg_id" {
  value       = data.aws_security_group.codebuild_sg.id
  description = "The ID of the Security Group."
}
