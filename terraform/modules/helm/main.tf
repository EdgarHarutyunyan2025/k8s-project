#========= HELM RELEASE ==========
resource "helm_release" "helm_application" {
  name             = var.application_name
  namespace        = var.application_namespace
  chart            = var.application_chart
  version          = var.application_version
  repository       = var.application_repository
  create_namespace = var.application_create_namespace

  values = var.application_values

}

