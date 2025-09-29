# ------------------------------------------------
# EC2 vars                                                
# ------------------------------------------------

# variable "subnet_id" {}

# ------------------------------------------------

variable "ins_type" {}

variable "vpc_id" {}

variable "ami" {}
variable "iam_ins_profile" {
  default = null
}
variable "pub_ip" {
  type    = bool
  default = null
}
variable "subnet_ids" {
  type = list(string)
}
variable "root_block_device" {
  type = list(object({
    volume_size = number
    volume_type = string
    encrypted   = bool
  }))
  default = []
}
variable "user_data" {
  type = string
}
variable "user_data_replace" {
  type    = bool
  default = null
}

variable "ec2_name" {}
variable "number" {
  type    = number
  default = 1
}

variable "tg_arns" {}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "desired_capacity" {
  type = number
}

