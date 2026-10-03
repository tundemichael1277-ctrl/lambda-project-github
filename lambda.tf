data "archive_file" "notes_service" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "notes_service" {
  function_name = "notes-service"

  role = aws_iam_role.notes_service_role.arn

  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"

  filename         = data.archive_file.notes_service.output_path
  source_code_hash = data.archive_file.notes_service.output_base64sha256

  timeout     = 10
  memory_size = 128
}