#======= ROLE POLICY =======

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = var.policy_arn
  role       = var.role
}
