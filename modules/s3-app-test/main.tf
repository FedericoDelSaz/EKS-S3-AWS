resource "kubernetes_namespace" "s3_app_nw" {
  metadata {
    name = var.namespace
  }
}

module "s3_app_test" {
  count       = var.app_s3_enabled ? 1 : 0
  source      = "./s3-app"
  namespace   = "s3-app-nw"
  bucket_name = var.bucket_name
  depends_on  = [kubernetes_namespace.s3_app_nw]
}