module "sg_ec2" {
  source = "../security_groups"
  vpc_id = var.vpc_id
  name   = "${var.proj_prefix}-ec2-sg"

  ingress_rules = [
    {
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port       = 80,
      to_port         = 80,
      protocol        = "tcp",
      security_groups = [module.sg_alb.sg_id]
    },
    {
      from_port       = 443,
      to_port         = 443,
      protocol        = "tcp",
      security_groups = [module.sg_alb.sg_id]
    }
  ]

  egress_rules = [
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

}

module "sg_alb" {
  source = "../security_groups"
  vpc_id = var.vpc_id
  name   = "${var.proj_prefix}-alb-sg"

  ingress_rules = [
    {
      from_port   = 80,
      to_port     = 80,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443,
      to_port     = 443,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

}