output "alb_dns_name" {
  value       = data.aws_lb.alb.dns_name
  description = "The DNS name of the Staging VPC."
}

output "alb_zone_id" {
  value       = data.aws_lb.alb.zone_id
  description = "The Zone ID of the Staging VPC."
}
