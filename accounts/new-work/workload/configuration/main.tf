resource "aws_route53_zone" "new_work_domain" {
  name = local.public_domain
}

resource "kubectl_manifest" "new_work_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${var.issue_name}
  namespace: ${var.namespace}
spec:
  acme:
    email: "felodel.valencia@gmail.com"
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: ${var.issue_name}
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
}

module "nginx_controller" {
  source = "../../../../modules/nginx-ingress-controller"
  cluster_name = var.cluster_name
}

module "hello_app" {
  source = "../../../../modules/s3-app-test/hello-world-app"
  namespace = var.namespace
}

module "ingress-" {
  source = "../../../../modules/s3-app-test/ingress-manifest"
  namespace = var.namespace
  issuer_name = var.issue_name
}
