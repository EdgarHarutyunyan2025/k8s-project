#========NGINX INGRESS CONTROLER========
resource "helm_release" "nginx_ingress" {
  provider         = helm.eks
  name             = "nginx-ingress"
  namespace        = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  create_namespace = true

  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
EOF
  ]
}
