variable "base_name" {
  type        = string
  description = "The base name of the IAM role"
}

variable "role_type" {
  type        = string
  description = "The type of the IAM role. 'AWS' or 'Service'"
}

variable "identifier" {
  type        = string
  description = "The identifier of the IAM role"
}

variable "policy_json" {
  type        = string
  description = "The policy json of the IAM role"
}
