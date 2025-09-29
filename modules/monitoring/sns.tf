resource "aws_sns_topic" "alerts" {
  name         = "${var.proj_prefix}-sns"
  display_name = var.display_name
}


resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}