output "id" {
  description = "The ID of the KMS key associated with the alias"
  value       = data.aws_kms_alias.this.target_key_id
}

output "arn" {
  description = "The ARN of the KMS key associated with the alias"
  value       = data.aws_kms_alias.this.arn
}
