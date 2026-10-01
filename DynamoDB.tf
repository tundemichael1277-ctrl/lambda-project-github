# Define the DynamoDB Table
resource "aws_dynamodb_table" "notes_table" {
  name         = "notes-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "noteId"
  range_key = "SignUpDate"

  # Partition Key
  attribute {
    name = "noteId"
    type = "S" # String
  }

  # Sort Key
  attribute {
    name = "SignUpDate"
    type = "N" # Number (Unix Timestamp)
  }

  # Enable Time to Live (TTL)
  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  # Enable Point-in-Time Recovery (Backup)
  point_in_time_recovery {
    enabled = true
  }

  # Encrypt data at rest using an AWS-managed KMS key
  server_side_encryption {
    enabled = true
  }
}