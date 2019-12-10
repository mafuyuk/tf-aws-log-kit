#####################################
# Lambda function Settings
#####################################
resource "null_resource" "yarn_install" {
  triggers = {
    package_json = "${base64sha256(file("${path.module}/package/package.json"))}"
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/setup.sh"
  }
}

data "archive_file" "zip" {
  depends_on  = ["null_resource.yarn_install"]
  type        = "zip"
  source_dir  = "${path.module}/package"
  output_path = "package-df.zip"
}

resource "aws_lambda_function" "delivery" {
  provider         = "aws.src"
  description      = "【${terraform.env}】CWL subscription func"
  function_name    = "${var.lambda_function_name}"
  filename         = "package-df.zip"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  handler          = "index.handler"
  role             = "${aws_iam_role.lambda.arn}"
  memory_size      = "128"
  runtime          = "nodejs6.10"
  timeout          = "120"

  environment = {
    variables = {
      NODE_ENV                     = "${terraform.env}"
      JOURNAL_DELIVERY_STREAM_NAME = "${var.fh_stream_journal_function_name}"
      ERROR_DELIVERY_STREAM_NAME   = "${var.fh_stream_error_function_name}"
      FH_ROLE_ARN                  = "${aws_iam_role.lambda_assume_for_fh.arn}"
      FH_REGION                    = "${var.dst_region}"
    }
  }
}

resource "aws_lambda_permission" "allow_cwl" {
  provider      = "aws.src"
  statement_id  = "${terraform.env}-allow-cwl"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.delivery.function_name}"
  principal     = "logs.${var.src_region}.amazonaws.com"
  source_arn    = "arn:aws:logs:${var.src_region}:${data.aws_caller_identity.src.account_id}:log-group:${var.cwl_log_group_name}*"
}

resource "aws_cloudwatch_log_subscription_filter" "delivery" {
  provider        = "aws.src"
  depends_on      = ["aws_lambda_permission.allow_cwl"]
  name            = "${var.cwl_log_group_name}-filter"
  log_group_name  = "${var.cwl_log_group_name}"
  filter_pattern  = "${var.cwl_filter_pattern}"
  destination_arn = "${aws_lambda_function.delivery.arn}"
}
