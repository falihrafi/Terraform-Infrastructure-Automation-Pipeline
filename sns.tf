resource "aws_sns_topic" "notification_topic" {
  name = "pipeline-email-notification"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = var.endpoint_email
  endpoint_auto_confirms = true
}
