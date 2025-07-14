#======= VPC =======

variable "region" {
  default = "eu-central-1"
}

variable "eks_vpc" {
  default = "10.0.0.0/16"
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


#======= EKS CLUSTER =======

variable "eks_cluter_name" {
  default = "my-eks-cluster"
}


variable "eks_enabled_cluster_log_types" {
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
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

#======= EKS SG =======

variable "ports" {
  default = ["80", "443"]
}

variable "protocol" {
  default = "tcp"
}

#======= CLUSTER ROLE & POLICY =======

variable "cluster_role_name" {
  default = "eks-cluster-role"
}

variable "cluster_service" {
  default = "eks.amazonaws.com"
}

variable "cluster_action" {
  default = "sts:AssumeRole"
}

variable "cluster_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

variable "cluster_service_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

#======= NODE ROLE & POLICY =======


variable "node_role_name" {
  default = "eks-worker-role"
}

variable "node_service" {
  default = "ec2.amazonaws.com"
}

variable "node_action" {
  default = "sts:AssumeRole"
}

variable "worker_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "registry_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

variable "cni_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


#======== OIDC TOKEN =======

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



#======= ACTION SYSTEM =======

variable "arc-system-name" {
  default = "arc-system"
}

variable "arc-system-namespace" {
  default = "arc-test"
}

variable "arc-system-chart" {
  default = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller"
}

variable "arc-system-version" {
  default = "0.12.1"
}

variable "arc-system-repository" {
  default = ""
}

variable "arc-system-create_namespace" {
  default = true
}

#======= ACTION RUNNER =======

variable "github_token" {
  default = ""
}

variable "value_file_path" {
  default = "/home/edgar/DevOps/kubernetes/my-project/action_runner/values.yaml"
}

variable "arc-runner-name" {
  default = "arc-runner"
}

variable "arc-runner-namespace" {
  default = "arc-runner"
}

variable "arc-runner-chart" {
  default = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set"
}

variable "arc-runner-version" {
  default = "0.12.1"
}

variable "arc-runner-repository" {
  default = ""
}

variable "arc-runner-create-namespace" {
  default = true
}
