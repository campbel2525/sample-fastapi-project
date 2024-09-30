
# ---------------------------------------------
# Subnet
# ---------------------------------------------
data "aws_subnet" "resource" {
  tags = {
    Name = var.subnet_name
  }
}
