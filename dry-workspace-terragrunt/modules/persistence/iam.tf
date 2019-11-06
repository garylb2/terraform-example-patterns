############################## Dynamo Read Only Access Policy ##############################################

resource "aws_iam_policy" "read_access_dynamodb" {
  name = "${var.resource-prefix}-data-read-access${var.resource-suffix}"
  path = "/acct-managed/"
  description = "allows read access dynamo data"
  policy = "${data.aws_iam_policy_document.data_read_access_doc.json}"
}

data "aws_iam_policy_document" "data_read_access_doc" {
  policy_id = "${var.resource-prefix}-data-read-access-doc"
  statement {
    sid = "1"
    actions = [
      "dynamodb:DescribeTimeToLive"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem"
    ]
    effect = "Allow"
    resources = [
      "${aws_dynamodb_table.data.arn}"
    ]
  }
}

resource "aws_iam_policy" "data_readwrite_access" {
  name = "${var.resource-prefix}-data-readwrite-access${var.resource-suffix}"
  path = "/acct-managed/"
  description = "allows read & write access dynamo data"
  policy = "${data.aws_iam_policy_document.readwrite_access_dynamodb_doc.json}"
}

data "aws_iam_policy_document" "readwrite_access_dynamodb_doc" {
  policy_id = "${var.resource-prefix}-data-readwrite-access-doc${var.resource-suffix}"
  statement {
    sid = "1"
    actions = [
      "dynamodb:DescribeTimeToLive"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem"
    ]
    effect = "Allow"
    resources = [
      "${aws_dynamodb_table.data.arn}"
    ]
  }
}