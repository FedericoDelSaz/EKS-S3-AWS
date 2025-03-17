resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = var.namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_ingress_version

  values = [
    file("${path.module}/files/values.yaml"),
    file(var.additional_values_file_path_nginx_custom)
  ]
}
