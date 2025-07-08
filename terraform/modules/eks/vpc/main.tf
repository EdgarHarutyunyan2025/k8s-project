#==========VPC============
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = "eks-vpc"
  }
}

#==========Availability Zones============

data "aws_availability_zones" "available" {}


#==========SUBNETS============

resource "aws_subnet" "eks_subnets" {
  count                   = var.eks_subnet_count
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name"                                 = "eks-subnet-${count.index}"
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }
}


#==========IGW============

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-igw"
  }
}

#==========ROUTE TABLES============

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.eks_subnet_count
  subnet_id      = aws_subnet.eks_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

