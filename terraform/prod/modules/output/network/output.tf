output "vpc_id" {
  value       = data.aws_vpc.vpc.id
  description = "The ID of the Staging VPC."
}

output "public_subnet_1a_id" {
  value       = data.aws_subnet.public_subnet_1a.id
  description = "The ID of the Public Subnet 1a."
}

output "public_subnet_1c_id" {
  value       = data.aws_subnet.public_subnet_1c.id
  description = "The ID of the Public Subnet 1c."
}

output "private_subnet_1a_id" {
  value       = data.aws_subnet.private_subnet_1a.id
  description = "The ID of the Private Subnet 1a."
}

output "private_subnet_1c_id" {
  value       = data.aws_subnet.private_subnet_1c.id
  description = "The ID of the Private Subnet 1c."
}

# output "public_rt_id" {
#   value       = data.aws_route_table.public_rt.id
#   description = "The ID of the Public Route Table."
# }

# output "private_rt_1a_id" {
#   value       = data.aws_route_table.private_rt_1a.id
#   description = "The ID of the Private Route Table 1a."
# }

# output "private_rt_1c_id" {
#   value       = data.aws_route_table.private_rt_1c.id
#   description = "The ID of the Private Route Table 1c."
# }

# output "igw_id" {
#   value       = data.aws_internet_gateway.igw.id
#   description = "The ID of the Internet Gateway."
# }

# output "ngw_1a_id" {
#   value       = data.aws_nat_gateway.ngw_1a.id
#   description = "The ID of the Nat Gateway."
# }
# output "ngw_1c_id" {
#   value       = data.aws_nat_gateway.ngw_1c.id
#   description = "The ID of the Nat Gateway."
# }
