#======= EKS CLUSTER =======

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


#======== OIDC TOKEN ========


module "oidec_token" {
  source = "../modules/oidc_role"

  oidc_provider_url         = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  service_account_name      = var.service_account_name
  service_account_namespace = var.service_account_namespace
}


#======== EBS DRIVER ========

module "helm" {
  source = "../modules/helm"

  providers = {
    helm = helm.eks
  }

  application_name             = var.ebs_driver_name
  application_namespace        = var.ebs_driver_namespace
  application_chart            = var.ebs_driver_chart
  application_version          = var.ebs_driver_version
  application_repository       = var.ebs_driver_repository
  application_create_namespace = var.ebs_driver_create_namespace
  #application_values           = var.helm_values_ebs
  application_values = [
    <<-EOT
  controller:
    serviceAccount:
      name: ebs-csi-controller-sa
      create: true
      annotations:
        eks.amazonaws.com/role-arn: ${module.oidec_token.ebs_csi_role_arn}
  EOT
  ]
}


#======== NGINC CONTROLER ========

module "nginx_controler" {
  source = "../modules/helm"

  providers = {
    helm = helm.eks
  }

  application_name             = var.nginx_controler_name
  application_namespace        = var.nginx_controler_namespace
  application_chart            = var.nginx_controler_chart
  application_version          = var.nginx_controler_version
  application_repository       = var.nginx_controler_repository
  application_create_namespace = var.nginx_controler_create_namespace
  application_values           = var.helm_values_nginx
}

#======== ARGO CD ========

module "argocd" {
  source = "../modules/helm"

  providers = {
    helm = helm.eks
  }
  application_name             = var.argocd_name
  application_namespace        = var.argocd_namespace
  application_chart            = var.argocd_chart
  application_version          = var.argocd_version
  application_repository       = var.argocd_repository
  application_create_namespace = var.argocd_create_namespace
  application_values           = var.helm_values_argocd
}
