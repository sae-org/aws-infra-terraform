# create a target group 
resource "aws_lb_target_group" "tg" {
  for_each = {
    for p in var.ports : tostring(p.port) => p
  } # creates a map of recources and holds all the target groups 
  # creates this map --> 
  # { each.key           each.value
  #   80  = (port = 80, protocol = "HTTP"),
  #   443 = (port = 443, protocol = "HTTPS")
  # }
  name     = "${var.name}-tg-${each.key}"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  tags = {
    Name = "${var.name}-tg-${each.key}"
  }
}

# attach tg to an instance
resource "aws_lb_target_group_attachment" "tg_attachments" {
  for_each = aws_lb_target_group.tg # says for all target groups created by .tg, create an attachment for each one
  # { each.key           each.value
  #   80  = (Target Group resource for port 80),
  #   443 = (Target Group resource for port 443)
  # }
  target_group_arn = each.value.arn
  target_id        = var.ec2_id
  port             = each.value.port
}