//Magic strings that happen to match up with resources controlled elsewhere
data "aws_caller_identity" "current" {}

locals {
  persistence-ro-policy-arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/acct-managed/${var.application-name}-data-read-access"
  data-table-name = "${var.application-name}-data"
}