variable "account_id" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "target_name" {
  type = string
}
variable "aws_tokyo_elb_account_id" {
  type = string
}
variable "tokyo_cert_arn" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_1a_id" {
  type = string
}
variable "public_subnet_1c_id" {
  type = string
}
variable "private_subnet_1a_id" {
  type = string
}
variable "private_subnet_1c_id" {
  type = string
}
variable "security_group_alb_sg_id" {
  type = string
}
variable "security_group_ecs_app_sg_id" {
  type = string
}
variable "health_check_path" {
  type = string
}
variable "container_definitions" {
  type = string
}
