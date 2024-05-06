resource "random_string" "random" {
  length  = var.length
  upper   = var.upper
  special = var.special
}
