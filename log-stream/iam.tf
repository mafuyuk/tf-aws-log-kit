#####################################
# IAM Role Settings
#####################################
resource "aws_iam_role" "fh" {
  name_prefix = "tf-log-stream"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "fh_to_s3" {
  role = "${aws_iam_role.fh.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject" ],
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket}",
        "arn:aws:s3:::${var.s3_bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "fh_to_es" {
  role = "${aws_iam_role.fh.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.es_region}:*"
    }
  ]
}
EOF
}
