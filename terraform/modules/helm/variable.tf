variable "eks_cluster_name" {
  #  default = aws_eks_cluster.eks_cluster.name
  default = "eks"
}
#======== PROVIDERS ========

variable "kubernetes_provider_host" {
  default = ""
}

variable "kubernetes_cluster_ca_certificate" {
  default = ""
}

variable "kubernetes_provider_token" {
  default = ""
}

variable "oidc_provider_url" {
  default = ""
}


#========NGINX INGRESS CONTROLER========

variable "nginx_ingress_name" {
  default = "nginx-ingress"
}

variable "nginx_ingress_namespace" {
  default = "nginx-ingress"
}

variable "nginx_ingress_chart" {
  default = "nginx-ingress"
}

variable "nginx_ingress_repository" {
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "nginx_create_namespace" {
  default = true
}

# =========EBS DRIVER==========


variable "ebs_driver_name" {
  default = "aws-ebs-csi-driver"
}

variable "ebs_driver_namespace" {
  default = "kube-system"
}

variable "ebs_driver_chart" {
  default = "aws-ebs-csi-driver"
}

variable "ebs_driver_version" {
  default = "2.45.1"
}

variable "ebs_driver_repository" {
  default = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
}



#=======ARGOCD========


variable "argocd_name" {
  default = "argocd"
}

variable "argocd_namespace" {
  default = "argocd"
}

variable "argocd_repository" {
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart" {
  default = "argo-cd"
}

variable "argocd_version" {
  default = "5.0.0"
}

variable "argocd_create_namespace" {
  default = true
}
