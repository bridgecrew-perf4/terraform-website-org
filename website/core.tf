variable "zone" {}
variable "core-website-domain" {}

resource "aws_route53_record" "website" {
  zone_id = var.zone.zone_id
  name    = var.core-website-domain
  type    = "A"

  alias {
    name                   = "kwiniaskaridge.github.io"
    zone_id                = var.zone.zone_id
    evaluate_target_health = true
  }
}
