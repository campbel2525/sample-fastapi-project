module "vpc" {
  source   = "../vpc"
  vpc_name = var.vpc_name
}

# ---------------------------------------------
# 仮想プライベートゲートウェイ
# 1つのvpcに紐づけれる仮想プライベートゲートウェイは1つ
# ---------------------------------------------
data "aws_vpn_gateway" "target" {
  filter {
    name   = "attachment.vpc-id"
    values = [module.vpc.id]
  }
}
