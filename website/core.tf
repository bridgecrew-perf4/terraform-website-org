variable "zone" {}
variable "core-website-domain" {}

resource "aws_route53_record" "website" {
  zone_id = var.zone.zone_id
  name    = var.core-website-domain
  type    = "A"
  ttl     = 14400

  records = [
    "kwiniaskaridge.github.io",
  ]
}
