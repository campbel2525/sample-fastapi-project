output "dns_name" {
  description = "ALB DNS name"
  value       = data.aws_lb.external_alb.dns_name
}

output "zone_id" {
  description = "ALB hosted zone ID"
  value       = data.aws_lb.external_alb.zone_id
}

output "arn" {
  description = "ALB ARN"
  value       = data.aws_lb.external_alb.arn
}
