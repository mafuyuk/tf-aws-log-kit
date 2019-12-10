variable "src_region" { default = "us-east-1" }
variable "dst_region" { default = "us-east-1" }

// lambda
variable "lambda_function_name" {}

// cwl

variable "cwl_filter_pattern" {}
variable "cwl_log_group_name" {}


// fh
variable "fh_stream_journal_function_name" {}
variable "fh_stream_journal_arn" {}
variable "fh_stream_error_function_name" {}
variable "fh_stream_error_arn" {}
