output "domain_records" {
  value = {
    for domain in var.acm_domains :
    domain => [
      for dvo in aws_acm_certificate.certs[domain].domain_validation_options : {
        name  = dvo.resource_record_name
        type  = dvo.resource_record_type
        value = dvo.resource_record_value
      }
    ]
  }
  description = "Map of subdomain to domain validation options for Route53"
}

output "certificate_arns" {
  value = {
    for domain, cert in aws_acm_certificate_validation.validation :
    domain => cert.certificate_arn
  }
  description = "Map of subdomain to ACM certificate ARN"
}
