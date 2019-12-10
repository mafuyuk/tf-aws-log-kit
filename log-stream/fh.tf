#####################################
# Kinesis Firehose stream Settings
#####################################
resource "aws_kinesis_firehose_delivery_stream" "stream" {
  name        = "${var.stream_name}"
  destination = "elasticsearch"

  s3_configuration {
    role_arn           = "${aws_iam_role.fh.arn}"
    bucket_arn         = "arn:aws:s3:::${var.s3_bucket}"
    prefix             = "${var.s3_prefix}"
    buffer_size        = 5
    buffer_interval    = 60
    compression_format = "UNCOMPRESSED"
  }

  elasticsearch_configuration {
    role_arn              = "${aws_iam_role.fh.arn}"
    domain_arn            = "arn:aws:es:${var.es_region}:${var.account_id}:domain/${var.es_domain}"
    index_name            = "${var.es_index}"
    type_name             = "${var.es_type}"
    buffering_interval    = 60
    buffering_size        = 5
    index_rotation_period = "OneDay"
    retry_duration        = 300
    s3_backup_mode        = "AllDocuments"
  }
}
