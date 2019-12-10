// aws
variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "region" {
  default = "us-west-2"
}

// lambda
variable "delivery_function_name" {
  default = "test-delivery"
}

// s3
variable "s3_bucket" {
  default = "test-archive-logs"
}

// es
variable "es_index" {
  default = "test-single-account"
}

variable "es_domain" {
  default = "dev-test-logs"
}

// cwl
variable "cwl_filter_pattern" {
  default = "[timestamp=*Z, request_id=\"*-*\", level, appname, msg]"
}

variable "cwl_log_group_name" {
  default = "/aws/lambda/tf-test"
}

// slack
variable "slack_hook_url" {
  default = "https://slack.com/apps/dummy-incoming-webhooks"
}

variable "slack_channel" {
  default = "general"
}

