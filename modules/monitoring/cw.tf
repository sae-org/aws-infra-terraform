resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "${var.asg_name}-avg-cpu-high"
  alarm_description   = "ASG average CPU is above threshold"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 60               
  evaluation_periods  = 3                 # 3 minutes window
  datapoints_to_alarm = 2                 # needs 2 of the 3 data points to breach
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  # Metric math: average CPUUtilization across all EC2 instances in this ASG
  # Every 60s period, take the Average of all instance CPU metrics found by SEARCH
  metric_query {
    id          = "e1"
    label       = "ASG Avg CPU"
    return_data = true
    expression  = "AVG(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" AND AutoScalingGroupName=\"${var.asg_name}\"', 'Average', 60))"
  }
}