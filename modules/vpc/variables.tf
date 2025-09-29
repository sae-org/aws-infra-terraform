variable "cidr_block" {
  type = string
}

variable "proj_prefix" {}

variable "vpc_az" {
  type = list(string)
}