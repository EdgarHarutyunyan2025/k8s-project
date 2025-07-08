output "role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "role_name" {
  value = aws_iam_role.eks_cluster_role.name
}
