#####################################
# IAM Role Settings.
#####################################
resource "aws_iam_role" "lambda" {
  provider = "aws.src"

  name_prefix = "tf-delivery-func"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_writes_to_cwe_policy" {
  provider = "aws.src"
  role     = "${aws_iam_role.lambda.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "fh_sts_policy" {
  provider = "aws.src"
  role     = "${aws_iam_role.lambda.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "${aws_iam_role.lambda_assume_for_fh.arn}"
    }
}
EOF
}

#####################################
# Assume Role Settings.
#####################################
resource "aws_iam_role" "lambda_assume_for_fh" {
  provider = "aws.dst"

  name_prefix = "tf-delivery-func"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.lambda.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_writes_to_fh_policy" {
  provider = "aws.dst"
  role     = "${aws_iam_role.lambda_assume_for_fh.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "firehose:PutRecordBatch",
      "Resource": [
        "${var.fh_stream_error_arn}",
        "${var.fh_stream_journal_arn}"
      ]
    }
  ]
}
EOF
}
