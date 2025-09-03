variable "acm_domains" {
  type = list(string)
}

variable "validation_method" {
  type = string
  default = "DNS"
}