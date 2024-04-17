# ---------------------------------------------
# VPC
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.65.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.66.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# ---------------------------------------------
# Route Table
# ---------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt-1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# ルートテーブルとサブネットの紐付け(明示的なサブネットの関連付け)
resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt_1a.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt_1c.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}


# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ---------------------------------------------
# Nat Gateway
# ---------------------------------------------
resource "aws_nat_gateway" "ngw_1a" {
  allocation_id = aws_eip.ngw_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name    = "${var.project}-${var.environment}-ngw-1a"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_nat_gateway" "ngw_1c" {
  allocation_id = aws_eip.ngw_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name    = "${var.project}-${var.environment}-ngw-1c"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_eip" "ngw_1a" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name    = "${var.project}-${var.environment}-eip-1a"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_eip" "ngw_1c" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name    = "${var.project}-${var.environment}-eip-1c"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "private_rt_ngw_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  nat_gateway_id         = aws_nat_gateway.ngw_1a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_rt_ngw_1c" {
  route_table_id         = aws_route_table.private_rt_1c.id
  nat_gateway_id         = aws_nat_gateway.ngw_1c.id
  destination_cidr_block = "0.0.0.0/0"
}
