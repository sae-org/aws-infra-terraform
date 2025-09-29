# Create a new load balancer
resource "aws_lb" "alb" {
  name               = "${var.proj_prefix}-lb"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  depends_on         = [var.depend_on]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = "${var.proj_prefix}-lb"
  }
}



