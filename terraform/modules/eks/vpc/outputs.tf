output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "subnet_id" {
  value = aws_subnet.eks_subnets[*].id
}

output "cidr_block" {
  value = aws_vpc.eks_vpc.cidr_block
}
