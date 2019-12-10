#####################################
# AWS provider settings
#####################################
provider "aws" {
  version                 = "~> 2"
  profile                 = "test"
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
}

data "aws_caller_identity" "test" {
}

