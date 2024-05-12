
# ---------------------------------------------
# albのlogを保存するバケット
# ---------------------------------------------
# alb log
resource "aws_s3_bucket" "alb_log" {
  bucket        = "${var.project_name}-${var.environment}-user-api-alb-log"
  force_destroy = true
}

# 設定
resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id = "alb-log-config"
    expiration {
      days = 90 # 削除する日程
    }
    status = "Enabled" # この設定を有効にするか
  }
}

# バージョニングしない
resource "aws_s3_bucket_versioning" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
