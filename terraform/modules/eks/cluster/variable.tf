#=====EKS CLUSTER=====

variable "eks_cluter_name" {
  default = "my-eks-cluster"
}

variable "eks_cluter_role_arn" {
  default = ""
}

variable "eks_cluter_subnet_ids" {
  default = ""
}

variable "eks_enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "eks_cluter_Policy" {
  default = ""
}

variable "eks_Service_Policy" {
  default = ""
}
