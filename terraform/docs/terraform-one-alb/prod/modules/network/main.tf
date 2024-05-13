data "aws_vpc" "vpc" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-vpc"
    Project = var.project_name
    Env     = var.environment
  }
}

data "aws_subnet" "public_subnet_1a" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-public-subnet-1a"
    Project = var.project_name
    Env     = var.environment
    Type    = "public"
  }
}

data "aws_subnet" "public_subnet_1c" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-public-subnet-1c"
    Project = var.project_name
    Env     = var.environment
    Type    = "public"
  }
}

data "aws_subnet" "private_subnet_1a" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-private-subnet-1a"
    Project = var.project_name
    Env     = var.environment
    Type    = "private"
  }
}

data "aws_subnet" "private_subnet_1c" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-private-subnet-1c"
    Project = var.project_name
    Env     = var.environment
    Type    = "private"
  }
}

data "aws_security_group" "alb_sg" {
  tags = {
    Name    = "${var.project_name}-${var.environment}-alb-sg"
    Project = var.project_name
    Env     = var.environment
  }
}

# data "aws_route_table" "public_rt" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-public-rt"
#     Project = var.project_name
#     Env     = var.environment
#     Type    = "public"
#   }
# }

# data "aws_route_table" "private_rt_1a" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-private-rt-1a"
#     Project = var.project_name
#     Env     = var.environment
#     Type    = "private"
#   }
# }

# data "aws_route_table" "private_rt_1c" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-private-rt-1c"
#     Project = var.project_name
#     Env     = var.environment
#     Type    = "private"
#   }
# }

# data "aws_internet_gateway" "igw" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-igw"
#     Project = var.project_name
#     Env     = var.environment
#   }
# }

# data "aws_nat_gateway" "ngw_1a" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-ngw-1a"
#     Project = var.project_name
#     Env     = var.environment
#   }
#   # filter = {
#   #   "name" = "vpc-id"
#   #   "values" = [
#   #     var.vpc_id
#   #   ]
#   # }
# }

# data "aws_nat_gateway" "ngw_1c" {
#   tags = {
#     Name    = "${var.project_name}-${var.environment}-ngw-1c"
#     Project = var.project_name
#     Env     = var.environment
#   }
#   # filter = {
#   #   "name" = "vpc-id"
#   #   "values" = [
#   #     var.vpc_id
#   #   ]
#   # }
# }
