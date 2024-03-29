##############################  Dynamo DB ###################################################

resource "aws_dynamodb_table" "data" {
  name           = "${var.resource-prefix}-data${var.resource-suffix}"
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
    Name        = "${var.resource-prefix}-data${var.resource-suffix}"
    Application = "example"
    Environment = "${var.env}"
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
