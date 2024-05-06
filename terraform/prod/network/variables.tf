# aws
variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

#東京リージョンのelbのアカウントIDのため固定
variable "aws_tokyo_elb_account_id" {
  type = string
}

# プロジェクトごとの設定
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_name" {
  type = string
}

# github
variable "github_owner" {
  type = string
}

variable "github_token" {
  type = string
}

variable "target_repository" {
  type = string
}

variable "target_branch" {
  type = string
}

variable "aws_codepipeline_webhook_secret" {
  type = string
}

variable "github_repository_webhook_secret" {
  type = string
}

variable "github_repository_url" {
  type = string
}

# route53
variable "aws_route53_record_zone_id" {
  type = string
}

# acm arn
variable "tokyo_cert_arn" {
  type = string
}

variable "virginia_cert_arn" {
  type = string
}

# aws lb listener arn
variable "aws_lb_listener_http_arn" {
  type = string
}

variable "aws_lb_listener_https_arn" {
  type = string
}

# アプリ名
variable "admin_api_name" {
  type = string
}

variable "user_api_name" {
  type = string
}

variable "admin_front_name" {
  type = string
}

variable "user_front_name" {
  type = string
}

# ドメイン
variable "admin_api_domain" {
  type = string
}

variable "user_api_domain" {
  type = string
}

variable "admin_front_domain" {
  type = string
}

variable "user_front_domain" {
  type = string
}
