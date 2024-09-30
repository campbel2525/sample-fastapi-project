# ---------------------------------------------
# RDS parameter group
# ---------------------------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "db1-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# ---------------------------------------------
# RDS option group
# ---------------------------------------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "db1-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# ---------------------------------------------
# RDS subnet group
# ---------------------------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "db1-mysql-standalone-subnetgroup"
  subnet_ids = [
    module.private_subnet_1a.id,
    module.private_subnet_1c.id,
  ]

  tags = {
    Name = "db1-mysql-standalone-subnetgroup"
  }
}

# ---------------------------------------------
# RDS instance
# ---------------------------------------------
resource "random_string" "db_password" {
  length  = 16
  upper   = true
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  engine         = "mysql"
  engine_version = "8.0.35"

  # DB インスタンス識別子情報
  identifier = "db1-mysql-standalone"

  username = "admin"
  password = random_string.db_password.result # 初期パスワード

  instance_class = "db.t3.micro"

  # ディスクの暗号化。
  # デフォルトのKMSの暗号鍵を使用するとこの設定を行うとアカウントを跨いだスナップショットが作れなくなるので、
  # 自分で作成した暗号鍵を使用する
  # kms_key_id                 = aws_kms_key.example.arn

  storage_encrypted     = true # 暗号化するかどうか？
  allocated_storage     = 20   # ストレージ容量
  max_allocated_storage = 50   # 最大何Gまで拡張できるか。この値まで自動的にスケールする
  storage_type          = "gp2"

  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [module.db_security_group.id]
  publicly_accessible    = false
  port                   = 3306

  db_name              = var.db_name # DB名
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name # 本番ではコメントアウトを外すこと

  # バックアップを行なってからメンテナンスを行うようにする
  backup_window              = "04:00-05:00"         # バックアップがおこなわれる時刻
  backup_retention_period    = 0                     # バックアップを何日くらい保管するか。本番では多めにしておくといいかも
  maintenance_window         = "Mon:05:00-Mon:08:00" # バックアップがおこなわれる時刻
  auto_minor_version_upgrade = false                 # DBのマイナーバージョンをアップデートするかどうか

  # 本番ではこちらを使用する
  # deletion_protection = true # 削除防止するか
  # skip_final_snapshot = false # 削除時のスナップショットをスキップするか
  # apply_immediately = false # 即時反映するか

  # rdsを削除する場合、以下の値を反映させてから削除する
  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = true

  # apply_immediatelyについて
  # rds作成後にはパスワードを変更するフローが入るので、apply_immediatelyは一旦trueで作成して、
  # パスワードを変更してからapply_immediately = falseにするのがいいと思う

  #
  # lifecycle {
  #   ignore_changes = [password]
  # }

  tags = {
    Name = "db1-mysql-standalone"
  }
}
