terraform {
  backend "s3" {
    bucket       = "argicd-tfstate-bucket"
    key          = "eks/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}



data "aws_eks_cluster" "cluster" {
  name       = module.eks-cluster.eks_cluster_name
  depends_on = [module.eks-cluster]
}


data "aws_eks_cluster_auth" "cluster_auth" {
  name       = module.eks-cluster.eks_cluster_name
  depends_on = [module.eks-cluster]
}
