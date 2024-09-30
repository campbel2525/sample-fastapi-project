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
    Name = "vpc"
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false # trueにするとここに設置したec2にipが付与される

  tags = {
    Name = "public-subnet-1a"
    Type = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false # trueにするとここに設置したec2にipが付与される

  tags = {
    Name = "public-subnet-1c"
    Type = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.65.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1a"
    Type = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.66.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1c"
    Type = "private"
  }
}

# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

# ---------------------------------------------
# Nat Gateway
# ---------------------------------------------
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  depends_on    = [aws_eip.ngw_eip]
  tags = {
    Name = "ngw"
  }
}

# ---------------------------------------------
# Nat Gateway eip
# ---------------------------------------------
resource "aws_eip" "ngw_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "eip"
  }
}

# ---------------------------------------------
# Route Table
# ---------------------------------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-rtb"
    Type = "public"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-rtb"
    Type = "private"
  }
}

# ---------------------------------------------
# Route
# ---------------------------------------------
resource "aws_route" "public_rt_igw" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_internet_gateway.igw]
}

resource "aws_route" "private_rt_ngw" {
  route_table_id         = aws_route_table.private_rtb.id
  nat_gateway_id         = aws_nat_gateway.ngw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_nat_gateway.ngw]
}

# ---------------------------------------------
# Route Table Association
# ルートテーブルとサブネットの紐付け(明示的なサブネットの関連付け)
# ---------------------------------------------
resource "aws_route_table_association" "public_rtb_to_public_subnet_1a" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rtb_to_public_subnet_1c" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table_association" "private_rtb_to_private_subnet_1a" {
  route_table_id = aws_route_table.private_rtb.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rtb_to_private_subnet_1c" {
  route_table_id = aws_route_table.private_rtb.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}
