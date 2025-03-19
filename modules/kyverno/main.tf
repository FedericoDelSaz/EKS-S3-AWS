resource "kubernetes_namespace" "new-work-policies" {
  metadata {
    name = var.kyverno_policies_chart_namespace
  }
}

resource "helm_release" "install-kyverno" {
  count = var.kyverno_enabled == "true" ? 1 : 0

  name       = "kyverno"
  namespace  = "new-work-policies"
  repository = "https://kyverno.github.io/kyverno"
  chart      = "kyverno"
  version    = var.kyverno_chart_version.chart_version

  values = [
    file("${path.module}/files/${var.kyverno_chart_version.values_file}"),
  ]

  depends_on = [
    kubernetes_namespace.new-work-policies
  ]
}

resource "helm_release" "install-kyverno-common-policies" {
  count = var.kyverno_enabled == "true" ? (var.kyverno_common_policies_enabled == "true" ? 1 : 0) : 0

  chart     = "${path.module}/kyverno-common-policies"
  name      = var.kyverno_common_policies_chart_name
  namespace = var.kyverno_policies_chart_namespace

  values = [
    file(var.kyverno_policies_values_file)
  ]

  depends_on = [
    helm_release.install-kyverno
  ]
}