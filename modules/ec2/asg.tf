resource "aws_autoscaling_group" "web_asg" {
  name                = "${var.ec2_name}-asg"
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  vpc_zone_identifier = var.subnet_ids # or use var.subnet_ids (list) across AZs

  # If you attach to an ALB/NLB, pass its TGs here:
  # target_group_arns         = var.tg_arns
  # health_check_type         = "ELB"
  # health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  # Replace instances when the LT changes (similar spirit to user_data_replace_on_change)
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
  }

  tag {
    key                 = "Name"
    value               = var.ec2_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "cpu-target-50"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50 # scale to keep average CPU ~50%
  }
}
