#resource "aws_route53_zone" "new_work_domain" {
#  name = var.dns_name
#}

resource "aws_route53_record" "new_work_dns" {
  zone_id = var.zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}