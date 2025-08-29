# listener for alb
resource "aws_lb_listener" "alb_listeners" {
  for_each = {
    for p in var.ports : tostring(p.port) => p
  }
  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = lower(each.value.protocol) == "https" ? var.cert_arn[var.primary_cert_domain] : null

  dynamic "default_action" {
    for_each = [each.value]
    content {
      type = default_action.value.port == 80 ? "redirect" : "forward"

      dynamic "redirect" {
        for_each = default_action.value.port == 80 ? [1] : [ ]
        content {
          port = "443"
          protocol = "HTTPS"
          status_code = var.http_status_code
        }
      }

      dynamic "forward" {
        for_each = default_action.value.port != 80 ? [1] : [ ]
        content {
          target_group {
          arn = aws_lb_target_group.tg["80"].arn
          }
        }
      }

    }
  }
}  


# add additional listener acm certs for other domains
resource "aws_lb_listener_certificate" "additional_certs" { 
  for_each = toset(var.extra_certs)
  listener_arn    = aws_lb_listener.alb_listeners["443"].arn
  certificate_arn = var.cert_arn[each.value]
}


# # rules for port 80
# resource "aws_lb_listener_rule" "rule_http" {
#   for_each = {
#     for p, l in aws_lb_listener.alb_listeners : p => l
#     if l.port == 80
#   }

#   listener_arn = each.value.arn
#   priority     = 1

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg["80"].arn
#   }

#   condition {
#     path_pattern {
#       values = ["/.well-known/*"]
#     }
#   }
# }


# # rules for port 443
# resource "aws_lb_listener_rule" "rule_https" {
#   for_each = {
#     for p, l in aws_lb_listener.alb_listeners : p => l
#     if l.port == 443
#   }

#   listener_arn = each.value.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg["80"].arn
#   }

#   condition {
#     host_header {
#       values = ["moh.saeeda.me", "tee.saeeda.me"]
#     }
#   }
# }



