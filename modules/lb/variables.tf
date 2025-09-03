variable "name" {
  type = string
  default = ""
}

variable "vpc_id" {}

variable "ec2_id" {}

variable "internal" {
  type = bool
  default = false
}

variable "lb_type" {
  type = string
  default = ""
}

variable "security_groups" {
  type = list(string)
  default = []
}

variable "subnets" {
  type = list(string)
  default = []
}

variable "depend_on" {
  type = list(string)
  default = []
}

variable "enable_deletion_protection" {
  type = bool
  default = false
}


variable "ports" {
  type = list(object({
    port = number
    protocol = string
  }))
  default = [
    { port = 80, protocol = "HTTP" },
    { port = 443, protocol = "HTTPS" }
  ]
}

variable "cert_arn" {}

variable "primary_cert_domain" {
  type = string
}

variable "http_status_code" {
  type = string
  default = "HTTP_301"
}

variable "extra_certs" {
  type = list(string)
  default = [ ]
}