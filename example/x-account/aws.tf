#####################################
# AWS provider settings
#####################################
provider "aws" {
  version                 = "~> 2.0"
  alias                   = "aggregate"
  profile                 = "aggregate"
  region                  = var.aggregate_region
  shared_credentials_file = var.shared_credentials_file
}

provider "aws" {
  version                 = "~> 2.0"
  alias                   = "sender"
  profile                 = "sender"
  region                  = var.sender_region
  shared_credentials_file = var.shared_credentials_file
}

data "aws_caller_identity" "aggregate" {
  provider = aws.aggregate
}

data "aws_caller_identity" "sender" {
  provider = aws.sender
}

