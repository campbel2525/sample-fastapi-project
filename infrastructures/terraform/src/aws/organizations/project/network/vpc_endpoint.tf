# ---------------------------------------------
# Vpc Endpoint
# private subnetに対してVPCエンドポイントを作成
# ---------------------------------------------

resource "aws_vpc_endpoint" "vpc_endpoint_ecr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_dkr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.private_rtb.id]

  tags = {
    Name = "s3-vpc-endpoint"
  }
}


# ---------------------------------------------
# 参考url
# https://dev.classmethod.jp/articles/vpc-endpoints-for-ecs-2022/
# https://qiita.com/ldr/items/7c8bc08baca1945fdb50
# 前にいた現場では、vpcエンドポイントは
# ecr.dkr, ecr.api, s3の3つのみでした
# logs, secretsmanager, ssm, ssmmessages
# もあるようです。要検討
# ---------------------------------------------

# # ログをCloudWatch Logsに送信するのに必要なエンドポイント
# resource "aws_vpc_endpoint" "logs" {
#   vpc_id            = aws_vpc.vpc.id
#   service_name      = "com.amazonaws.${var.aws_region}.logs"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
#   subnet_ids         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

#   private_dns_enabled = true

#   tags = {
#     Name    = "vpc-logs-endpoint"
#     Env     = var.environment
#   }
# }

# # タスク定義でSecrets Managerの値を環境変数として渡すように指定していた場合、必要なエンドポイント
# resource "aws_vpc_endpoint" "secretsmanager" {
#   vpc_id            = aws_vpc.vpc.id
#   service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
#   subnet_ids         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

#   private_dns_enabled = true

#   tags = {
#     Name    = "secretsmanager-vpc-endpoint"
#     Env     = var.environment
#   }
# }

# # SSMパラメータストアを利用するのに必要なエンドポイント
# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id            = aws_vpc.vpc.id
#   service_name      = "com.amazonaws.${var.aws_region}.ssm"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
#   subnet_ids         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

#   private_dns_enabled = true

#   tags = {
#     Name    = "ssm-vpc-endpoint"
#     Env     = var.environment
#   }
# }

# # ECS Execは稼働中のコンテナにログインできる機能です。
# # この機能はSSM Session Managerを利用しておりcom.amazonaws.region.ssmmessagesのVPCエンドポイントが必要
# resource "aws_vpc_endpoint" "ssmmessages" {
#   vpc_id            = aws_vpc.vpc.id
#   service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
#   subnet_ids         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

#   private_dns_enabled = true

#   tags = {
#     Name    = "ssmmessages-vpc-endpoint"
#     Env     = var.environment
#   }
# }

# ---------------------------------------------
# Security Group
# ---------------------------------------------
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "vpc endpoint role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_sg_in_all" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 443
  cidr_blocks       = ["10.0.0.0/16"]
}


resource "aws_security_group_rule" "vpc_endpoint_sg_out_all" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
