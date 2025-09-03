
resource "aws_route53_zone" "public_hosted_zone" {
  count = var.create_domain ? 1 : 0
  name  = var.domain_name
}


resource "time_sleep" "wait_5_mins" {
  depends_on = [aws_route53_zone.public_hosted_zone]

  create_duration = "500s"
}

# add records in route 53


resource "aws_route53_record" "site_domains" {
  depends_on = [time_sleep.wait_5_mins]
  for_each = {
    for subdomain, records in var.r53_domains :
    subdomain => records[0]
  }
  zone_id = aws_route53_zone.public_hosted_zone[0].zone_id
  name    = each.value.name
  records = try(each.value.alias, null) != null ? null : toset([tostring(each.value.value)])
  ttl     = try(each.value.alias, null) != null ? null : try(each.value.ttl, 300)
  type    = each.value.type

  dynamic "alias" {
    for_each = try(each.value.alias, null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
