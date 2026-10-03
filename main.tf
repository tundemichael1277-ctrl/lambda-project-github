resource "aws_dynamodb_table" "notes_table" {
  name         = "notes-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "noteId"
  range_key = "SignUpDate"

  attribute {
    name = "noteId"
    type = "S"
  }

  attribute {
    name = "SignUpDate"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }
}
