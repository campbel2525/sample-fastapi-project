# # プロファイル名の指定
# variable "profile" {
#   description = "Profile name configured in the AWS CLI"
#   type        = string
# }

# 他アカウントのALBが存在するリージョン
# variable "region" {
#   description = "Region where other account's ALB exists"
#   type        = string
# }

# 取得したいALBの名前
variable "alb_name" {
  description = "Name of ALB you want to get"
  type        = string
}
