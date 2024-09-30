resource "aws_iam_instance_profile" "ec2_for_ssm" {
  name = "ec2-for-ssm"
  role = module.ec2_for_ssm_role.name

  depends_on = [
    module.ec2_for_ssm_role,
  ]
}

resource "aws_instance" "ec2_for_banstion" {
  ami                  = "ami-078296f82eb463377"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_for_ssm.name
  subnet_id            = module.private_subnet_1a.id
  user_data            = file("./user_data.sh")

  tags = {
    Name = "banstion-ec2-for-banstion"
  }

  vpc_security_group_ids = [
    module.ec2_security_group.id
  ]
}

resource "aws_s3_bucket" "banstion" {
  bucket        = "terraform-banstion-log"
  force_destroy = true
}

# 設定
resource "aws_s3_bucket_lifecycle_configuration" "banstion" {
  bucket = aws_s3_bucket.banstion.id

  rule {
    id = "banstion-config"

    expiration {
      days = 180 # 削除する日程
    }

    status = "Enabled" # この設定を有効にするか
  }
}

# バージョニングしない
resource "aws_s3_bucket_versioning" "banstion" {
  bucket = aws_s3_bucket.banstion.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_cloudwatch_log_group" "banstion" {
  name              = "/aws/ec2/banstion"
  retention_in_days = 180
}

resource "aws_ssm_document" "session_manager_run_shell" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to open given port connection over Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName           = aws_s3_bucket.banstion.id
      cloudWatchLogGroupName = aws_cloudwatch_log_group.banstion.name
    }
  })
}
