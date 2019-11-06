## Remote State
terraform {
  backend "s3" { }
}

locals {
  resource-prefix = "${var.application-name}"
  suffix-delimiter = "${terraform.workspace == "default" ? "" : "-"}"
  resource-suffix = "${terraform.workspace == "default" ? "" : format("%s%s", local.suffix-delimiter, terraform.workspace)}"
  env = "${terraform.workspace == "default" ? var.default-environment : terraform.workspace}"
}


module "persistence" {
  source = "../persistence"

  resource-prefix = "${local.resource-prefix}"
  resource-suffix = "${local.resource-suffix}"
  env = "${local.env}"
  region = "${var.region}"
}

module "api" {
  source = "../api"

  resource-prefix = "${local.resource-prefix}"
  resource-suffix = "${local.resource-suffix}"
  env = "${local.env}"
  region = "${var.region}"
  api-secret-key-base = "${var.api-secret-key-base}"
  persistence-ro-policy-arn = "${module.persistence.persistence-ro-policy-arn}"
  data-table-name = "${module.persistence.table-name}"
}
