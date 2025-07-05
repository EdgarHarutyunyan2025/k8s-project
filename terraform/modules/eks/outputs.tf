output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

#output "cluster_endpoint" {
#  value = data.aws_eks_cluster.cluster.endpoint
#}
#
#output "cluster_auth_token" {
#  value = data.aws_eks_cluster_auth.cluster_auth.token
#}
#
#output "kubernetes_cluster_ca_certificate" {
#  value = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#}
#
#output "oidc_token" {
#  value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
#}
