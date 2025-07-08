#======= VPC  =======

module "vpc" {
  source               = "../modules/eks/vpc"
  eks_vpc              = var.eks_vpc
  eks_subnet_count     = var.eks_subnet_count
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

#======= EKS CLUSTER =======

module "eks-cluster" {
  source                        = "../modules/eks/cluster"
  eks_cluter_name               = var.eks_cluter_name
  eks_enabled_cluster_log_types = var.eks_enabled_cluster_log_types
  eks_cluter_role_arn           = module.eks_cluster_role.role_arn
  eks_cluter_subnet_ids         = module.vpc.subnet_id
  eks_cluter_Policy             = module.eks_cluster_policy
  eks_Service_Policy            = module.eks_service_policy
}

#======= NODE GROUP =======

module "node-group" {
  source                    = "../modules/eks/node_group"
  cluster_name              = module.eks-cluster.eks_cluster_name
  node_group_name           = var.node_group_name
  node_role_arn             = module.eks_worker_role.role_arn
  subnet_ids                = module.vpc.subnet_id
  source_security_group_ids = [module.eks-sg.sg_id]
  worker_Node_Policy        = module.eks_worker_policy
  depends_on = [
    module.eks_worker_policy,
    module.container_Registry_policy,
    module.cni_policy,
    module.eks-cluster,
  ]

}

#======= EKS SG =======

module "eks-sg" {
  source      = "../modules/eks/security_group/"
  vpc_id      = module.vpc.vpc_id
  cidr_blocks = [module.vpc.cidr_block]
  ports       = var.ports
  protocol    = var.protocol
}

#======= CLUSTER ROLE & POLICY =======

module "eks_cluster_role" {
  source    = "../modules/eks/role"
  role_name = var.cluster_role_name
  service   = var.cluster_service
  action    = var.cluster_action
}

module "eks_cluster_policy" {
  source     = "../modules/eks/role_policy"
  policy_arn = var.cluster_policy_arn
  role       = module.eks_cluster_role.role_name
}

module "eks_service_policy" {
  source     = "../modules/eks/role_policy"
  policy_arn = var.cluster_service_policy_arn
  role       = module.eks_cluster_role.role_name
}

#======= NODE ROLE & POLICY =======


module "eks_worker_role" {
  source    = "../modules/eks/role"
  role_name = var.node_role_name
  service   = var.node_service
  action    = var.node_action
}

module "eks_worker_policy" {
  source     = "../modules/eks/role_policy"
  policy_arn = var.worker_policy_arn
  role       = module.eks_worker_role.role_name
}

module "container_Registry_policy" {
  source     = "../modules/eks/role_policy"
  policy_arn = var.registry_policy_arn
  role       = module.eks_worker_role.role_name
}

module "cni_policy" {
  source     = "../modules/eks/role_policy"
  policy_arn = var.cni_policy_arn
  role       = module.eks_worker_role.role_name
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

  depends_on = [module.node-group]
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

  depends_on = [module.node-group]
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

  depends_on = [module.node-group]
}
