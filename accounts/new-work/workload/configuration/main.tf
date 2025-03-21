module "new_worl_alb" {
  source = "../../../../modules/aws-alb"
  vpc_id = local.vpc_id
  public_subnets = local.public_eks_subnets
  vpc_name = "eks-vpc"
}

module "new_work_route53" {
  source = "../../../../modules/aws-route53"
  dns_name = local.public_domain
  zone_id = module.new_worl_alb.zone_id
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
  source       = "../../../../modules/nginx-ingress-controller"
  cluster_name = var.cluster_name
}

module "hello_app" {
  source    = "../../../../modules/s3-app-test/hello-world-app"
  namespace = var.namespace
}

module "render_image_app_local" {
  source      = "../../../../modules/s3-app-test/render-image-app-local"
  bucket_name = "s3-bucket-render-image"
  namespace   = var.namespace
  environment = "dev"
}

module "render_image_app" {
  source      = "../../../../modules/s3-app-test/render-image-app"
  bucket_name = "s3-bucket-render-image"
  namespace   = var.namespace
  environment = "dev"
}

module "ingress_nginx" {
  source      = "../../../../modules/s3-app-test/ingress-manifest"
  namespace   = var.namespace
  issuer_name = var.issue_name
  alb_name    = module.new_worl_alb.alb_name
}

module "kyverno" {
  source                          = "../../../../modules/kyverno"
  kyverno_enabled                 = "true"
  kyverno_common_policies_enabled = "true"
}
