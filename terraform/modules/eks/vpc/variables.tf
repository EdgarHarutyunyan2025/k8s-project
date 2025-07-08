#=====EKS VPC=====

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
