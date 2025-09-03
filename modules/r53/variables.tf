variable "domain_name" {
  type = string
  default = ""
}

variable "r53_domains" {
  type = any
  default = []
}

variable "create_domain" {
  type = bool
}
