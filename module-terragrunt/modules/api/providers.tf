provider "aws" {
  region = "${var.region}"
}

## Remote State
terraform {
  backend "s3" { }
}
