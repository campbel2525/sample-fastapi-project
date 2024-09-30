output "arn" {
  description = "The ARN of the WAF Rule Group"
  value       = data.aws_wafv2_rule_group.target_rule_group.arn
}
