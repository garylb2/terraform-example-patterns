
############################## API Gateway ##############################################

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.application-name}-api-${var.env}"
  description = "Set of API resources to support web integrations for Ford and Lincoln"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    "aws_api_gateway_method.get_code_method",
    "aws_api_gateway_integration.integration"]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name = "${var.env}"

  #TODO - likely where the tags will end up when implemented
}


############################## API key definition #########################################################
resource "aws_api_gateway_api_key" "api_key" {
  name = "${var.application-name}-api-key-${var.env}"
  value = "${var.application-name}_${var.api-secret-key-base}_${var.env}"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "api_key_usage_plan" {
  name = "${var.application-name}-api-usage-plan-${var.env}"
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
