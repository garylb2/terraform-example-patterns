output persistence-ro-policy-arn {
  value = "${aws_iam_policy.read_access_dynamodb.arn}"
}

output "table-name" {
  value = "${aws_dynamodb_table.data.name}"
}