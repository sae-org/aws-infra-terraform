resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "${var.asg_name}-avg-cpu-high" 
  alarm_description   = "ASG average CPU is above threshold"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 65
  period              = 60
  evaluation_periods  = 3 # 3 minutes window
  datapoints_to_alarm = 2 # needs 2 of the 3 data points to breach
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}