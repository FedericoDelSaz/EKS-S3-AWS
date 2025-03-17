resource "aws_route53_zone" "new_work_domain" {
  name = "new-work-se-test.com"
}

module "nginx_controller" {
  source = "../../../../modules/nginx-ingress-controller"
  cluster_name = var.cluster_name
}
