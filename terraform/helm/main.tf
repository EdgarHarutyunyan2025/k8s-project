#========HELM========

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}


data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}



module "helm" {
  source = "../modules/helm"

  oidc_provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  kubernetes_provider_host          = data.aws_eks_cluster.cluster.endpoint
  kubernetes_cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  kubernetes_provider_token         = data.aws_eks_cluster_auth.cluster_auth.token


  eks_cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  ebs_driver_name       = var.ebs_driver_name
  ebs_driver_namespace  = var.ebs_driver_namespace
  ebs_driver_chart      = var.ebs_driver_chart
  ebs_driver_version    = var.ebs_driver_version
  ebs_driver_repository = var.ebs_driver_repository


  nginx_ingress_name       = var.nginx_ingress_name
  nginx_ingress_namespace  = var.nginx_ingress_namespace
  nginx_ingress_chart      = var.nginx_ingress_chart
  nginx_ingress_repository = var.nginx_ingress_repository
  nginx_create_namespace   = var.nginx_create_namespace

  argocd_name             = var.argocd_name
  argocd_namespace        = var.argocd_namespace
  argocd_repository       = var.argocd_repository
  argocd_chart            = var.argocd_chart
  argocd_version          = var.argocd_version
  argocd_create_namespace = var.argocd_create_namespace

}
