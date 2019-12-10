#####################################
# AWS Authentication
#####################################
provider "aws" {
  alias  = "src"
}

provider "aws" {
  alias  = "dst"
}

data "aws_caller_identity" "src" {
  provider = "aws.src"
}
