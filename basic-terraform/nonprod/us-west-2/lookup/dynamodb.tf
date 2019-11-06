##############################  Dynamo DB ###################################################

resource "aws_dynamodb_table" "data" {
  name           = "${local.application-name}-data"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "customerId"
  range_key      = ""

  attribute = [{
    name = "customerId"
    type = "S"
  }]

  ttl {
    attribute_name = "TimeToExist"
    enabled = false
  }

  ## stop redeploying TTL
  lifecycle {
    ignore_changes = ["ttl"]
  }

  global_secondary_index {
    name               = "customerIdIndex"
    hash_key           = "customerId"
    range_key          = ""
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "KEYS_ONLY"
    non_key_attributes = []
  }

  server_side_encryption {
    enabled = "true"
  }

  point_in_time_recovery {
    enabled = "false"
  }

  stream_enabled = "false"
  stream_view_type = ""

  timeouts {
    create = "10m"
    delete = "10m"
    update = "10m"
  }

  tags {
    Name        = "${local.application-name}"
    Application = "example"
    Environment = "${local.env}"
  }
}

##################################### Dynamo Example Item #################################################

resource "aws_dynamodb_table_item" "example" {
  table_name = "${aws_dynamodb_table.data.name}"
  hash_key = "${aws_dynamodb_table.data.hash_key}"
  item = <<ITEM
{
  "customerId": {"S": "99998-F"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}

############################## Dynamo Read Only Access Policy ##############################################

resource "aws_iam_policy" "read_access_dynamodb" {
  name = "${local.application-name}-data-read-access"
  path = "/acct-managed/"
  description = "allows read access dynamo data"
  policy = "${data.aws_iam_policy_document.data_read_access_doc.json}"
}

data "aws_iam_policy_document" "data_read_access_doc" {
  policy_id = "${local.application-name}-data-read-access-doc"
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
  name = "${local.application-name}-data-readwrite-access"
  path = "/acct-managed/"
  description = "allows read & write access dynamo data"
  policy = "${data.aws_iam_policy_document.readwrite_access_dynamodb_doc.json}"
}

data "aws_iam_policy_document" "readwrite_access_dynamodb_doc" {
  policy_id = "${local.application-name}-data-readwrite-access-doc"
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