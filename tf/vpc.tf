# Create a VPC for the EKS cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "eks-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create private subnets for the VPC
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnets[count.index]

  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Create public subnets for the VPC
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnets[count.index]

  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

#Create Elastic IP for NAT Gateway
resource "aws_eip" "eip" {
  domain = "vpc"
}

#Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "my-eks-igw"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public[0].id

  depends_on = [ 
    aws_eip.eip,
    aws_internet_gateway.igw
   ]
  tags = {
    Name = "NAT Gateway for node group"
  }
}

#Create Route table to route traffic from private subnets through the NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Associate the route table with your private subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}