# creating security group for alb (internet --> alb) and ec2 (alb --> ec2)
resource "aws_security_group" "sg" {
  name   = var.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = length(try(ingress.value.cidr_blocks, [])) > 0 ? ingress.value.cidr_blocks : null
      security_groups = length(try(ingress.value.security_groups, [])) > 0 ? ingress.value.security_groups : null
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = length(try(egress.value.cidr_blocks, [])) > 0 ? egress.value.cidr_blocks : null
      security_groups = length(try(egress.value.security_groups, [])) > 0 ? egress.value.security_groups : null
    }
  }

  tags = {
    Name = var.name
  }
}
