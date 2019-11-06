############################## API Gateway ##############################################

resource "aws_api_gateway_rest_api" "api" {
  name = "${local.application-name}-api"
  description = "Set of API resources to support web integrations for Ford and Lincoln"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    "aws_api_gateway_method.get_customer_id_method",
    "aws_api_gateway_integration.integration"]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name = "${local.env}"

  #TODO - likely where the tags will end up when implemented
}


############################## API key definition #########################################################
resource "aws_api_gateway_api_key" "api_key" {
  name = "${local.application-name}-api-key"
  value = "${local.application-name}_${local.api-secret-key-base}_${local.env}"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "api_key_usage_plan" {
  name = "${local.application-name}-api-usage-plan"
  description = "Defines the plan for usage on the give api key"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.api.id}"
    stage = "${aws_api_gateway_deployment.api_deployment.stage_name}"
  }

  quota_settings {
    limit  = 10000
    offset = 0
    period = "DAY"
  }
  throttle_settings {
    burst_limit = 5
    rate_limit  = 5
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api_key_usage_plan.id}"
}

resource "aws_api_gateway_resource" "parent" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part = "DC"
}

##############################  Get Data By CustomerId ###################################################
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
  uri                     = "arn:aws:apigateway:${local.region}:dynamodb:action/GetItem"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates {
    "application/json"    =  <<TEMPLATE
{
  "TableName": "${aws_dynamodb_table.data.name}",
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

##############################  API IAM ROLES ###################################################
resource "aws_iam_role" "api_role" {
  name = "${local.application-name}-api-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
                "iam:AddUserToGroup",
                "iam:AddClientIDToOpenIDConnectProvider",
                "iam:AttachGroupPolicy",
                "iam:CreateAccountAlias",
                "iam:CreateGroup",
                "iam:CreateOpenIDConnectProvider",
                "iam:CreateSAMLProvider",
                "iam:CreateUser",
                "iam:CreateVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteAccountAlias",
                "iam:DeleteAccountPasswordPolicy",
                "iam:DeleteGroup",
                "iam:DeleteGroupPolicy",
                "iam:DeleteLoginProfile",
                "iam:DeleteOpenIDConnectProvider",
                "iam:DeleteSAMLProvider",
                "iam:DeleteSSHPublicKey",
                "iam:DeleteSigningCertificate",
                "iam:DeleteUser",
                "iam:DeleteVirtualMFADevice",
                "iam:DetachGroupPolicy",
                "iam:EnableMFADevice",
                "iam:PutGroupPolicy",
                "iam:RemoveClientIDFromOpenIDConnectProvider",
                "iam:RemoveUserFromGroup",
                "iam:ResyncMFADevice",
                "iam:UpdateAccountPasswordPolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:UpdateGroup",
                "iam:UpdateLoginProfile",
                "iam:UpdateOpenIDConnectProviderThumbprint",
                "iam:UpdateSAMLProvider",
                "iam:UpdateSSHPublicKey",
                "iam:UpdateSigningCertificate",
                "iam:UpdateUser",
                "iam:UploadSSHPublicKey",
                "iam:UploadSigningCertificate",
                "sts:AssumeRoleWithSAML",
                "sts:AssumeRoleWithWebIdentity",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:TagUser",
                "iam:UntagUser"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api_dynamo_access" {
  role       = "${aws_iam_role.api_role.name}"
  policy_arn = "${aws_iam_policy.read_access_dynamodb.arn}"
}