output "topic_id" {
  value = "${aws_sns_topic.notification.id}"
}

output "topic_arn" {
  value = "${aws_sns_topic.notification.arn}"
}

output "lambda_id" {
  value = "${aws_lambda_function.notification.id}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.notification.arn}"
}
