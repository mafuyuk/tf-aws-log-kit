#####################################
# log operation settings
#####################################
module "create_notification" {
  source         = "git::https://github.com/mafuyuk/tf-aws-log-kit//slack-notification?ref=master"
  s3_bucket      = var.s3_bucket
  slack_hook_url = var.slack_hook_url
  slack_channel  = var.slack_channel
}

module "create_info_stream" {
  source      = "git::https://github.com/mafuyuk/tf-aws-log-kit//log-stream?ref=master"
  account_id  = data.aws_caller_identity.test.account_id
  stream_name = "${terraform.env}-${var.es_index}-info"
  s3_bucket   = var.s3_bucket
  s3_prefix   = "AWSLogs/${data.aws_caller_identity.test.account_id}/${var.es_index}/info/${terraform.env}/"
  es_region   = var.region
  es_domain   = var.es_domain
  es_index    = var.es_index
  es_type     = "info"
}

module "create_error_stream" {
  source      = "git::https://github.com/mafuyuk/tf-aws-log-kit//log-stream?ref=master"
  account_id  = data.aws_caller_identity.test.account_id
  stream_name = "${terraform.env}-${var.es_index}-error"
  s3_bucket   = var.s3_bucket
  s3_prefix   = "AWSLogs/${data.aws_caller_identity.test.account_id}/${var.es_index}/error/${terraform.env}/"
  es_region   = var.region
  es_domain   = var.es_domain
  es_index    = var.es_index
  es_type     = "error"
}

module "create_delivery_func" {
  source = "git::https://github.com/mafuyuk/tf-aws-log-kit//delivery-func?ref=master"

  providers = {
    aws.src = aws
    aws.dst = aws
  }

  src_region                      = var.region
  dst_region                      = var.region
  lambda_function_name            = var.delivery_function_name
  cwl_filter_pattern              = var.cwl_filter_pattern
  cwl_log_group_name              = var.cwl_log_group_name
  fh_stream_journal_function_name = module.create_info_stream.stream_name
  fh_stream_journal_arn           = module.create_info_stream.stream_arn
  fh_stream_error_function_name   = module.create_error_stream.stream_name
  fh_stream_error_arn             = module.create_error_stream.stream_arn
}

