##############################  Get Data By CustomerId ###################################################
resource "aws_api_gateway_resource" "parent" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part = "DC"
}
resource "aws_api_gateway_resource" "get_customer_id" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id = "${aws_api_gateway_resource.parent.id}"
  path_part = "{customerId}"
}

resource "aws_api_gateway_method" "get_customer_id_method" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.get_customer_id.id}"
  http_method = "GET"
  authorization = "NONE"
  api_key_required=true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.get_customer_id.id}"
  http_method             = "${aws_api_gateway_method.get_customer_id_method.http_method}"

  integration_http_method = "POST"

  // AWS Service Passthru
  type                    = "AWS"
  credentials             = "${aws_iam_role.api_role.arn}"
  uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/GetItem"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates {
    "application/json"    =  <<TEMPLATE
{
  "TableName": "${local.data-table-name}",
  "Key": {
    "customerId": { "S": "$input.params('customerId')" }
  }
}
TEMPLATE
  }
}

// AWS Service Passthru supporting configuration
resource "aws_api_gateway_method_response" "success" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.get_customer_id.id}"
  http_method = "${aws_api_gateway_method.get_customer_id_method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  depends_on = [
    "aws_api_gateway_integration.integration"]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.get_customer_id.id}"
  http_method = "${aws_api_gateway_method.get_customer_id_method.http_method}"
  status_code = "${aws_api_gateway_method_response.success.status_code}"

  //  response_templates {
  //    "application/json"    =  <<EOF
  //#set($inputRoot = $input.path('$.Item'))
  //  {
  //    "customerId": "$inputRoot.customerId.S",
  //    "one": "$inputRoot.one.N"
  //  }
  //EOF
  //  }
}