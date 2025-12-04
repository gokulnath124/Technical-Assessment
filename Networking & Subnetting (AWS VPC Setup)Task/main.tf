provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "gokul_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Gokulnath_Dharmalingam_VPC"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Gokulnath_Dharmalingam_Public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Gokulnath_Dharmalingam_Public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Gokulnath_Dharmalingam_Private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Gokulnath_Dharmalingam_Private2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.gokul_vpc.id

  tags = {
    Name = "Gokulnath_Dharmalingam_IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.gokul_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Gokulnath_Dharmalingam_PublicRT"
  }
}

resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "Gokulnath_Dharmalingam_NATGW"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.gokul_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "Gokulnath_Dharmalingam_PrivateRT"
  }
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}
