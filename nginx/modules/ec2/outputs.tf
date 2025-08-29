output "instance_ids" {
  value = aws_instance.webserver[*].id
}

output "instance_arn" {
  value = aws_instance.webserver[*].arn
}

output "sg_alb_id" {
  value = module.sg_alb.sg_id
  
}
