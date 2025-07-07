variable "oidc_provider_url" {
  default = ""
}

variable "policy_arn" {
  default = ""
}

variable "service_account_name" {
  default = "ebs-csi-controller-sa"
}

variable "service_account_namespace" {
  default = "kube-system"
}

