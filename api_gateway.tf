resource "aws_apigatewayv2_api" "notes_api" {
  name          = "notes-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "notes_lambda" {
  api_id                 = aws_apigatewayv2_api.notes_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.notes_service.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "notes" {
  api_id    = aws_apigatewayv2_api.notes_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.notes_lambda.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notes_service.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.notes_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.notes_api.id
  name        = "$default"
  auto_deploy = true
}