#========EKS CLUSTER=========
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluter_name
  role_arn = var.eks_cluter_role_arn
  vpc_config {
    subnet_ids = var.eks_cluter_subnet_ids
  }
  enabled_cluster_log_types = var.eks_enabled_cluster_log_types
  depends_on = [
    var.eks_cluter_Policy,
    var.eks_Service_Policy,
  ]
}
