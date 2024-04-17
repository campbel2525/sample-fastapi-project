# ---------------------------------------------
# 学習用のバケット
# ---------------------------------------------
resource "aws_s3_bucket" "learning_bucket" {
  bucket        = "${var.project}-${var.environment}-learning-data-nsoihfbaos8"
  force_destroy = true

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_headers = ["*"]
    max_age_seconds = 3600
  }
}

# バージョニングしない
resource "aws_s3_bucket_versioning" "learning_bucket" {
  bucket = aws_s3_bucket.learning_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}
