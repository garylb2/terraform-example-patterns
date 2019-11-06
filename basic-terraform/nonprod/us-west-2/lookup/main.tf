provider "aws" {
  region = "${local.region}"
}

locals {
  app-id = "basic-terraform"
  application-name = "example-${local.app-id}"
  env = "dev"

  region = "us-west-2"

  api-secret-key-base = "blahblahblah"
}

## Remote State

terraform {
  backend "s3" {
    bucket          = "awsdpsnp-cox-ddc-pse-terraform-state"
    key             = "example/basic-terraform/np/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = true
    dynamodb_table  = "awsdpsnp-cox-ddc-pse-tf-state-lock"
  }
}