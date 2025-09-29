# ----------------------------------------------------------------
# EC2 outputs                                                    
# ----------------------------------------------------------------

# output "instance_ids" {
#   value = aws_instance.webserver[*].id
# }

# output "instance_arn" {
#   value = aws_instance.webserver[*].arn
# }

# ----------------------------------------------------------------

output "sg_alb_id" {
  value = module.sg_alb.sg_id

}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "asg_arn" {
  value = aws_autoscaling_group.web_asg.arn
}

output "launch_template_id" {
  value = aws_launch_template.web_lt.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.web_lt.latest_version
}


output "tls_private_key" {
  value = tls_private_key.dev_key.private_key_pem
}