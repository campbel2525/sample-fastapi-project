variable "app_name" {
  type        = string
  description = "The name of the Amplify app."
}

variable "repository_url" {
  type        = string
  description = "The repository URL linked with the Amplify app."
}

variable "oauth_token" {
  type        = string
  description = "OAuth token for repository access."
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Amplify app."
  default     = {}
}


# variable "branch_name" {
#   type        = string
#   description = "The branch name in the Amplify app."
# }
