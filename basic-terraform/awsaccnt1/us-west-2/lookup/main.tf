provider "aws" {
  region = "${local.region}"
}

locals {
  app-id = "basic-terraform"
  application-name = "example-${local.app-id}"
  env = "test"

  region = "us-west-2"

  api-secret-key-base = "blahblahblah"
}

## Remote State

terraform {
  backend "s3" {
    bucket          = "awscoxautolabs16-cox-ddc-pse-terraform-state"
    key             = "example/basic-terraform/lab/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = true
    dynamodb_table  = "awslab16-cox-ddc-pse-tf-state-lock"
  }
}