output "eks_cluster_name" {
  value = module.eks-cluster.eks_cluster_name
}

output "oidc_role_arn" {
  value = module.oidec_token.ebs_csi_role_arn
}

