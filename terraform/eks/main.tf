provider "aws" {
  region = var.region
}


module "eks-cluster" {
  source               = "../modules/eks"
  eks_cluter_name      = var.eks_cluter_name
  eks_vpc              = var.eks_vpc
  eks_subnet_count     = var.eks_subnet_count
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  node_group_name     = var.node_group_name
  node_ami_type       = var.node_ami_type
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  node_min_size       = var.node_min_size
  node_ec2_ssh_key    = "eu-central-1-ec2-key"
}


#========HELM========

#data "aws_eks_cluster" "cluster" {
#  name = module.eks-cluster.eks_cluster_name
#}
#
#
#data "aws_eks_cluster_auth" "cluster_auth" {
#  name = module.eks-cluster.eks_cluster_name
#}



#module "helm" {
#  source = "./helm"
#
#  oidc_provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
#
#  kubernetes_provider_host          = data.aws_eks_cluster.cluster.endpoint
#  kubernetes_cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#  kubernetes_provider_token         = data.aws_eks_cluster_auth.cluster_auth.token
#
#
#  eks_cluster_name = module.eks-cluster.eks_cluster_name
#
#  ebs_driver_name       = "aws-ebs-csi-driver"
#  ebs_driver_namespace  = "kube-system"
#  ebs_driver_chart      = "aws-ebs-csi-driver"
#  ebs_driver_version    = "2.45.1"
#  ebs_driver_repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
#
#
#  nginx_ingress_name       = "nginx-ingress"
#  nginx_ingress_namespace  = "ingress-nginx"
#  nginx_ingress_chart      = "ingress-nginx"
#  nginx_ingress_repository = "https://kubernetes.github.io/ingress-nginx"
#  nginx_create_namespace   = true
#
#  argocd_name             = "argocd"
#  argocd_namespace        = "argocd"
#  argocd_repository       = "https://argoproj.github.io/argo-helm"
#  argocd_chart            = "argo-cd"
#  argocd_version          = "5.0.0"
#  argocd_create_namespace = true
#
#}
#
