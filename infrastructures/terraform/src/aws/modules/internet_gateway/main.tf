data "aws_internet_gateway" "target" {
  tags = {
    Name = var.internet_gateway_name
  }
}
