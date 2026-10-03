output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = aws_apigatewayv2_api.notes_api.api_endpoint
}