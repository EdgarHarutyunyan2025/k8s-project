variable "cluster_name" {
  default = ""
}

variable "node_role_arn" {
  default = ""
}

variable "subnet_ids" {
  default = ""
}

variable "source_security_group_ids" {
  type    = list(string)
  default = []
}

variable "worker_Node_Policy" {
  default = ""
}

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

variable "node_sg_ports" {
  default = ["80", "443"]
}
