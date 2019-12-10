#####################################
# SNS topic Settings
#####################################
resource "aws_sns_topic" "notification" {
  name = "${aws_lambda_function.notification.function_name}"

  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:${aws_lambda_function.notification.function_name}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"arn:aws:s3:::${var.s3_bucket}"}
        }
    }]
}
EOF
}

resource "aws_sns_topic_subscription" "notification_lambda" {
  topic_arn = "${aws_sns_topic.notification.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.notification.arn}"
}

#####################################
# Lambda permission Settings
#####################################
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notification.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.notification.arn}"
}
