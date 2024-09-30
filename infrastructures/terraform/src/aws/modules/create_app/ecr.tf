resource "aws_ecr_repository" "ecr_app" {
  name = "${var.target_name}-app"

  # ecr内のimage強制的に削除する
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "ecr_app" {
  repository = aws_ecr_repository.ecr_app.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["release"],
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}
