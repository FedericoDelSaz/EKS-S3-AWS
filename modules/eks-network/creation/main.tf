# Create VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.aws_vpc_cidr_block

  tags = {
    Name = "eks-vpc"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_3_cidr_block
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-3"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_3_cidr_block
  availability_zone = var.availability_zones[2]

  tags = {
    Name = "private-subnet-3"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

# Create a NAT Gateway for private subnets (requires an Elastic IP)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "eks-nat-gw"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = var.public_rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "eks-public-rt"
  }
}

# Create a Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = var.private_rt_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "eks-private-rt"
  }
}
