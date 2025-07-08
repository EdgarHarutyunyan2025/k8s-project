# ========= HELM APPLICATION ==========

variable "application_name" {
  default = "aws-ebs-csi-driver"
}

variable "application_namespace" {
  default = "kube-system"
}

variable "application_chart" {
  default = "aws-ebs-csi-driver"
}

variable "application_version" {
  default = "2.45.1"
}

variable "application_repository" {
  default = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
}

variable "application_create_namespace" {
  default = false
}

variable "application_values" {
  type    = list(string)
  default = []
}

