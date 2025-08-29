# requesting a certificate for all my domains will prove ownership via dns 

# get the domain_validation_options (CNAME ACM gives) and feed that into R53 

# ACM then validates 
resource "aws_acm_certificate" "certs" {
  for_each = toset(var.acm_domains)
  domain_name       = each.value
  validation_method = var.validation_method
}

resource "aws_acm_certificate_validation" "validation" {
  for_each = aws_acm_certificate.certs
  certificate_arn = each.value.arn
  validation_record_fqdns = [
    for dvo in each.value.domain_validation_options : dvo.resource_record_name
  ]
}