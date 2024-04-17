# aws
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

# プロジェクトごとの設定
variable "project" {
  type = string
}

variable "environment" {
  type = string
}
