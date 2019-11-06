//Magic strings that happen to match up with resources controlled elsewhere
locals {
  persistence-ro-policy-arn = "arn:aws:iam::${var.account-id}:policy/acct-managed/${var.application-name}-data-read-access"
  data-table-name = "${var.application-name}-data"
}