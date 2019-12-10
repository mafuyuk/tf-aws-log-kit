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
  output_path = "package-sn.zip"
}

resource "aws_lambda_function" "notification" {
  description      = "【${terraform.env}】Slack通知を行います"
  function_name    = "${terraform.env}-notification"
  filename         = "package-sn.zip"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  handler          = "index.handler"
  role             = "${aws_iam_role.lambda.arn}"
  memory_size      = "128"
  runtime          = "nodejs6.10"
  timeout          = "120"

  environment = {
    variables = {
      HOOK_URL = "${var.slack_hook_url}"
      CHANNEL  = "${var.slack_channel}"
    }
  }
}
