#==========VPC============
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "eks-vpc"
  }
}

#==========Availability Zones============

data "aws_availability_zones" "available" {}


#==========SUBNETS============

resource "aws_subnet" "eks_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true # Публичные подсети для простоты
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
  count          = 2
  subnet_id      = aws_subnet.eks_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

