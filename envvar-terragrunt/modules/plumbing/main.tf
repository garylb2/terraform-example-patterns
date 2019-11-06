## Remote State
terraform {
  backend "s3" { }
}

module "persistence" {
  source = "../persistence"

  application-name = "${var.application-name}"
  env = "${var.env}"
  region = "${var.region}"
}

module "api" {
  source = "../api"

  application-name = "${var.application-name}"
  env = "${var.env}"
  region = "${var.region}"
  api-secret-key-base = "${var.api-secret-key-base}"
  persistence-ro-policy-arn = "${module.persistence.persistence-ro-policy-arn}"
  data-table-name = "${module.persistence.table-name}"
}
