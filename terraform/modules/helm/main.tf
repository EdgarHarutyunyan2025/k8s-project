provider "aws" {
  region = "eu-central-1"
}


#data "aws_eks_cluster" "cluster" {
#  name = var.eks_cluster_name
#}
#
#
#data "aws_eks_cluster_auth" "cluster_auth" {
#  name = var.eks_cluster_name
#}
#
#
#provider "kubernetes" {
#  alias                  = "eks"
#  host                   = data.aws_eks_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#  token                  = data.aws_eks_cluster_auth.cluster_auth.token
#}
#
#provider "helm" {
#  alias = "eks"
#
#  kubernetes = {
#    host                   = data.aws_eks_cluster.cluster.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#    token                  = data.aws_eks_cluster_auth.cluster_auth.token
#  }
#}

#========NGINX INGRESS CONTROLER========
resource "helm_release" "nginx_ingress" {
  provider         = helm.eks
  name             = var.nginx_ingress_name
  namespace        = var.nginx_ingress_namespace
  chart            = var.nginx_ingress_chart
  repository       = var.nginx_ingress_repository
  create_namespace = var.nginx_create_namespace

  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
EOF
  ]
}

# =========EBS DRIVER==========
resource "helm_release" "ebs_csi_driver" {
  provider   = helm.eks
  name       = var.ebs_driver_name
  namespace  = var.ebs_driver_namespace
  chart      = var.ebs_driver_chart
  version    = var.ebs_driver_version
  repository = var.ebs_driver_repository

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
  #  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  url = var.oidc_provider_url
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


#=======ARGOCD========
resource "helm_release" "argocd" {
  provider   = helm.eks
  name       = var.argocd_name
  namespace  = var.argocd_namespace
  repository = var.argocd_repository
  chart      = var.argocd_chart
  version    = var.argocd_version

  create_namespace = var.argocd_create_namespace

  values = [
    <<-EOT
    server:
      service:
        type: LoadBalancer
    EOT
  ]

}

