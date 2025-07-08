variable "vpc_id" {
  default = ""
}

variable "cidr_blocks" {
  default = []
}

variable "ports" {
  default = ["80", "443"]
}

variable "protocol" {
  default = "tcp"
}
