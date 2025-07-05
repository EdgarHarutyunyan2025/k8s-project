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

