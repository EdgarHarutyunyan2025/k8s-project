variable "role_name" {
  default = "eks-cluster-role"
}

variable "service" {
  default = "eks.amazonaws.com"
}

variable "action" {
  default = "sts:AssumeRole"
}
