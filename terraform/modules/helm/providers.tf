#data "aws_eks_cluster" "cluster" {
#  name = var.eks_cluster_name
#}
#
#
#data "aws_eks_cluster_auth" "cluster_auth" {
#  name = var.eks_cluster_name
#}


provider "kubernetes" {
  alias = "eks"
  #  host                   = data.aws_eks_cluster.cluster.endpoint
  #  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  #  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  host                   = var.kubernetes_provider_host
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  token                  = var.kubernetes_provider_token
}

provider "helm" {
  alias = "eks"

  kubernetes = {
    #    host                   = data.aws_eks_cluster.cluster.endpoint
    #    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    #    token                  = data.aws_eks_cluster_auth.cluster_auth.token
    host                   = var.kubernetes_provider_host
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
    token                  = var.kubernetes_provider_token
  }
}


