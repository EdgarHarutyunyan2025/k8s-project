resource "helm_release" "argocd" {
  provider   = helm.eks
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.0.0"

  create_namespace = true

  values = [
    <<-EOT
    server:
      service:
        type: LoadBalancer
    EOT
  ]

}
