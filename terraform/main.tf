#provider "aws" {
#  region = "eu-central-1"
#}
#
## VPC
#resource "aws_vpc" "eks_vpc" {
#  cidr_block           = "10.0.0.0/16"
#  enable_dns_hostnames = true
#  enable_dns_support   = true
#  tags = {
#    Name = "eks-vpc"
#  }
#}
#
## Подсети
#data "aws_availability_zones" "available" {}
#
#resource "aws_subnet" "eks_subnets" {
#  count                   = 2
#  vpc_id                  = aws_vpc.eks_vpc.id
#  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
#  availability_zone       = data.aws_availability_zones.available.names[count.index]
#  map_public_ip_on_launch = true # Публичные подсети для простоты
#  tags = {
#    "Name"                                 = "eks-subnet-${count.index}"
#    "kubernetes.io/cluster/my-eks-cluster" = "shared"
#  }
#}
#
## Internet Gateway и маршруты
#resource "aws_internet_gateway" "igw" {
#  vpc_id = aws_vpc.eks_vpc.id
#  tags = {
#    Name = "eks-igw"
#  }
#}
#
#resource "aws_route_table" "public" {
#  vpc_id = aws_vpc.eks_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.igw.id
#  }
#}
#
#resource "aws_route_table_association" "public" {
#  count          = 2
#  subnet_id      = aws_subnet.eks_subnets[count.index].id
#  route_table_id = aws_route_table.public.id
#}

# IAM роль для EKS кластера
#resource "aws_iam_role" "eks_cluster_role" {
#  name = "eks-cluster-role"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect    = "Allow"
#      Principal = { Service = "eks.amazonaws.com" }
#      Action    = "sts:AssumeRole"
#    }]
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.eks_cluster_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#  role       = aws_iam_role.eks_cluster_role.name
#}

# EKS кластер
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
  ]
}

# IAM роль для узлов
#resource "aws_iam_role" "eks_worker_role" {
#  name = "eks-worker-role"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect    = "Allow"
#      Principal = { Service = "ec2.amazonaws.com" }
#      Action    = "sts:AssumeRole"
#    }]
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.eks_worker_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.eks_worker_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.eks_worker_role.name
#}

# Группа безопасности для узлов
#resource "aws_security_group" "eks_worker_sg" {
#  vpc_id = aws_vpc.eks_vpc.id
#  ingress {
#    description = "Allow nodes to communicate with each other"
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    self        = true
#  }
#  ingress {
#    description = "Allow cluster API server to communicate with nodes"
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = [aws_vpc.eks_vpc.cidr_block]
#  }
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  tags = {
#    Name = "eks-worker-sg"
#  }
#}

# Node group с двумя узлами
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "example-node-group"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = aws_subnet.eks_subnets[*].id
  ami_type        = "AL2023_x86_64_STANDARD"
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  remote_access {
    source_security_group_ids = [aws_security_group.eks_worker_sg.id]
    ec2_ssh_key               = "eu-central-1-ec2-key"
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_worker_AmazonEKS_CNI_Policy,
    aws_eks_cluster.eks_cluster,
  ]
}
