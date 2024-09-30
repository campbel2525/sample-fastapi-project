variable "rule_group_name" {
  description = "The name of the WAF Rule Group"
  type        = string
}

variable "scope" {
  description = "The scope of the WAF Rule Group (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"
}
