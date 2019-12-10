output "lambda_id" {
  value = "${aws_lambda_function.delivery.id}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.delivery.arn}"
}

output "src_account_id" {
  value = "${data.aws_caller_identity.src.account_id}"
}
