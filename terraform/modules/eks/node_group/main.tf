#=========EKC NODE GROUP=========
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  ami_type        = var.node_ami_type
  instance_types  = var.node_instance_types
  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }
  remote_access {
    source_security_group_ids = var.source_security_group_ids
    ec2_ssh_key               = var.node_ec2_ssh_key
  }
}
