variable "zone" {}
variable "core-website-domain" {}

resource "aws_s3_bucket" "non-www-to-core" {
  # The bucket name must be the fqdn it responds to
  bucket = var.zone.name

  website {
    redirect_all_requests_to = "https://${var.core-website-domain}"
  }
}

resource "aws_route53_record" "non-www-to-core" {
  zone_id = var.zone.zone_id
  name    = var.zone.name
  type    = "A"

  alias {
    name                   = aws_s3_bucket.non-www-to-core.website_domain
    zone_id                = aws_s3_bucket.non-www-to-core.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_s3_bucket" "www-to-core" {
  # If the current zone is the core website domain,
  # do not create a bucket or A record
  count = "www.${var.zone.name}" == var.core-website-domain ? 0 : 1
  # The bucket name must be the fqdn it responds to
  bucket = "www.${var.zone.name}"

  website {
    redirect_all_requests_to = "https://${var.core-website-domain}"
  }
}

resource "aws_route53_record" "www-to-core" {
  # If the current zone is the core website domain,
  # do not create a bucket or A record
  count = "www.${var.zone.name}" == var.core-website-domain ? 0 : 1
  zone_id = var.zone.zone_id
  name    = "www.${var.zone.name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.www-to-core[0].website_domain
    zone_id                = aws_s3_bucket.www-to-core[0].hosted_zone_id
    evaluate_target_health = true
  }
}
