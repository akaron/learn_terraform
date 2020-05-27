# Internet VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "myvpc"
  }
}

# Subnets
resource "aws_subnet" "myvpc-public-1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = local.aza

  tags = {
    Name = "myvpc-public-1"
  }
}

resource "aws_subnet" "myvpc-public-2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "172.16.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = local.azb

  tags = {
    Name = "myvpc-public-2"
  }
}

resource "aws_subnet" "myvpc-public-3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "172.16.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = local.azc

  tags = {
    Name = "myvpc-public-3"
  }
}

resource "aws_subnet" "myvpc-private-1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "172.16.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = local.aza

  tags = {
    Name = "myvpc-private-1"
  }
}

resource "aws_subnet" "myvpc-private-2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "172.16.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = local.azb

  tags = {
    Name = "myvpc-private-2"
  }
}

resource "aws_subnet" "myvpc-private-3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "172.16.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = local.azc

  tags = {
    Name = "myvpc-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "myvpc-gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myvpc"
  }
}

# route tables
resource "aws_route_table" "myvpc-public" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpc-gw.id
  }

  tags = {
    Name = "myvpc-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "myvpc-public-1-a" {
  subnet_id      = aws_subnet.myvpc-public-1.id
  route_table_id = aws_route_table.myvpc-public.id
}

resource "aws_route_table_association" "myvpc-public-2-a" {
  subnet_id      = aws_subnet.myvpc-public-2.id
  route_table_id = aws_route_table.myvpc-public.id
}

resource "aws_route_table_association" "myvpc-public-3-a" {
  subnet_id      = aws_subnet.myvpc-public-3.id
  route_table_id = aws_route_table.myvpc-public.id
}

