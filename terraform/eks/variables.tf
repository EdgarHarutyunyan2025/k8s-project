#======= EKS CLUSTER =======

variable "region" {
  default = "eu-central-1"
}

variable "eks_cluter_name" {
  default = "my-eks-cluster"
}

variable "eks_vpc" {
  default = "10.10.0.0/16"
}

variable "eks_subnet_count" {
  default = 2
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}



#======= EKS NODE GROUP =======

variable "node_group_name" {
  default = "example-node-group"
}

variable "node_ami_type" {
  default = "AL2023_x86_64_STANDARD"
}

variable "node_instance_types" {
  default = ["t3.medium"]
}

variable "node_desired_size" {
  default = 2
}

variable "node_max_size" {
  default = 3
}

variable "node_min_size" {
  default = 1
}

variable "node_ec2_ssh_key" {
  default = "eu-central-1-ec2-key"
}

#======= OIDC TOKEN =======

variable "service_account_name" {
  default = "ebs-csi-controller-sa"
}

variable "service_account_namespace" {
  default = "kube-system"
}

#======= HELM EBS DRIVER =======

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

variable "ebs_driver_create_namespace" {
  default = false
}


#======= HELM NGINX INGRESS =======


variable "nginx_controler_name" {
  default = "nginx-ingress"
}

variable "nginx_controler_namespace" {
  default = "ingress-nginx"
}

variable "nginx_controler_chart" {
  default = "ingress-nginx"
}

variable "nginx_controler_version" {
  default = "4.12.3"
}

variable "nginx_controler_repository" {
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "nginx_controler_create_namespace" {
  default = true
}

variable "helm_values_nginx" {
  default = [
    <<-EOT
    server:
      service:
        type: "LoadBalancer"
    EOT
  ]
}


#======= ARGO CD =======

variable "argocd_name" {
  default = "argocd"
}

variable "argocd_namespace" {
  default = "argocd"
}

variable "argocd_chart" {
  default = "argo-cd"
}

variable "argocd_version" {
  default = "5.0.0"
}

variable "argocd_repository" {
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_create_namespace" {
  default = true
}

variable "helm_values_argocd" {
  default = [
    <<-EOT
    server:
      service:
        type: "LoadBalancer"
    EOT
  ]
}

