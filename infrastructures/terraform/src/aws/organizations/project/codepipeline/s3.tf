# ---------------------------------------------
# s3
# ---------------------------------------------
resource "aws_s3_bucket" "artifact" {
  bucket        = "terraform-artifact-${random_string.artifact_bucket.result}"
  force_destroy = true
}

# 設定
resource "aws_s3_bucket_lifecycle_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    id = "codepipeline-config"
    expiration {
      days = 90 # 削除する日程
    }
    status = "Enabled" # この設定が有効
  }
}

# バージョニングしない
resource "aws_s3_bucket_versioning" "artifact" {
  bucket = aws_s3_bucket.artifact.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_codestarconnections_connection" "codepipeline" {
  name          = "github-connection"
  provider_type = "GitHub"
}
