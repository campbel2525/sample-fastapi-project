resource "aws_amplify_app" "app" {
  name        = var.app_name
  repository  = var.repository_url
  oauth_token = var.oauth_token

  environment_variables = var.environment_variables
}

# resource "aws_amplify_branch" "branch" {
#   app_id      = aws_amplify_app.app.id
#   branch_name = var.branch_name
# }
