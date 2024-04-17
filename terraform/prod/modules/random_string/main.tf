resource "random_string" "random" {
  length  = 8
  upper   = false
  special = false
}

output "random_string" {
  value = random_string.random.result
}
