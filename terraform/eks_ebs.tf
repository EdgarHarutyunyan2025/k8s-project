# =========EBS DRIVER==========
resource "helm_release" "ebs_csi_driver" {
  provider   = helm.eks
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  chart      = "aws-ebs-csi-driver"
  version    = "2.45.1"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"

  set = [
    {
      name  = "controller.serviceAccount.name"
      value = "ebs-csi-controller-sa"
    },
    {
      name  = "controller.serviceAccount.create"
      value = "true"
    },
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = "arn:aws:iam::877680973630:role/AmazonEKS_EBS_CSI_DriverRole"
    }
  ]

}


#========OIDC=========

resource "aws_iam_openid_connect_provider" "eks_OIDC" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd40bd5"]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}



#=======ROLE FOR EBS========

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_OIDC.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks_OIDC.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attach" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

