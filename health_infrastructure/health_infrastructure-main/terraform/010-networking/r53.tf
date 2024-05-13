resource "aws_route53_zone" "primary" {
  name = var.domain_name

  tags = var.tags
}

## Get the parent zone ID
data "aws_route53_zone" "parent" {
  name = var.parent_domain_name
}

## Add NS to the parent domain
resource "aws_route53_record" "parent_ns" {
  zone_id = data.aws_route53_zone.parent.zone_id
  name    = var.domain_name
  type    = "NS"
  ttl     = 300
  records = [
    for ns in aws_route53_zone.primary.name_servers : ns
  ]
}
