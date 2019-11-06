locals {
  app-id = "module-terraform"
  application-name = "example-${local.app-id}"
  env = "dev"

  region = "us-west-2"

  api-secret-key-base = "blahblahblah"
}

## Remote State

terraform {
  backend "s3" {
    bucket          = "awscoxautolabs16-cox-ddc-pse-terraform-state"
    key             = "example/module-terraform/lab/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = true
    dynamodb_table  = "awslab16-cox-ddc-pse-tf-state-lock"
  }
}

module "api" {
  source = "../../../modules/api"

  application-name = "${local.application-name}"
  env = "${local.env}"
  region = "${local.region}"
  api-secret-key-base = "${local.api-secret-key-base}"
  persistence-ro-policy-arn = "${module.persistence.persistence-ro-policy-arn}"
  data-table-name = "${module.persistence.table-name}"
}

module "persistence" {
  source = "../../../modules/persistence"

  application-name = "${local.application-name}"
  env = "${local.env}"
  region = "${local.region}"
}