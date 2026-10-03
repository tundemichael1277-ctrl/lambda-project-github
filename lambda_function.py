import json
import uuid
import boto3
import logging
import time

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# DynamoDB table
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("notes-table")


def lambda_handler(event, context):

    # Log the incoming event
    logger.info("Received event: %s", json.dumps(event))

    # Extract HTTP method
    method = event["requestContext"]["http"]["method"]

    # POST - Create a new note
    if method == "POST":
        body = json.loads(event.get("body", "{}"))

        note_id = str(uuid.uuid4())
        signup_date = int(time.time())

        item = {
            "noteId": note_id,
            "SignUpDate": signup_date,
            "content": body.get("content", "")
        }

        table.put_item(Item=item)

        logger.info(
            "Created note: %s with content: %s",
            note_id,
            item["content"]
        )

        return {
            "statusCode": 201,
            "body": json.dumps(item)
        }

    # GET - Retrieve all notes
    if method == "GET":
        notes = table.scan()["Items"]

        logger.info("Retrieved %d notes", len(notes))

        return {
            "statusCode": 200,
            "body": json.dumps(notes, default=int)
        }

    # PUT - Update an existing note
    if method == "PUT":
        body = json.loads(event.get("body", "{}"))

        note_id = body.get("noteId")
        signup_date = body.get("SignUpDate")
        content = body.get("content", "")

        if not note_id or signup_date is None:
            return {
                "statusCode": 400,
                "body": "Missing noteId or SignUpDate"
            }

        table.update_item(
            Key={
                "noteId": note_id,
                "SignUpDate": int(signup_date)
            },
            UpdateExpression="SET content = :c",
            ExpressionAttributeValues={
                ":c": content
            }
        )

        return {
            "statusCode": 200,
            "body": "Updated"
        }

    # DELETE - Remove a note
    if method == "DELETE":
        body = json.loads(event.get("body", "{}"))

        note_id = body.get("noteId")
        signup_date = body.get("SignUpDate")

        if not note_id or signup_date is None:
            return {
                "statusCode": 400,
                "body": "Missing noteId or SignUpDate"
            }

        table.delete_item(
            Key={
                "noteId": note_id,
                "SignUpDate": int(signup_date)
            }
        )

        return {
            "statusCode": 200,
            "body": "Deleted"
        }

    return {
        "statusCode": 400,
        "body": "Unsupported"
    }