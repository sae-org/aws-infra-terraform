output "lb_arn" {
  value = aws_lb.alb.arn
}

output "lb_dns" {
  value = aws_lb.alb.dns_name
}

output "lb_zone" {
  value = aws_lb.alb.zone_id
}

output "tg_arns" {
  value = [for k, tg in aws_lb_target_group.tg : tg.arn]
}