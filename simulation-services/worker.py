import json
import math
import os
import random
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

def estimate_pi(total_points: int) -> float:
    inside_circle = 0
    for _ in range(total_points):
        x = random.uniform(-1, 1)
        y = random.uniform(-1, 1)
        if x * x + y * y <= 1:
            inside_circle += 1
    return 4.0 * inside_circle / total_points

def lambda_handler(event, context):
    detail = event.get("detail", {})
    if isinstance(detail, str):
        detail = json.loads(detail)

    job_id = detail["job_id"]
    total_points = int(detail["total_points"])
    pi_value = estimate_pi(total_points)

    table.put_item(
        Item={
            "job_id": job_id,
            "total_points": total_points,
            "pi_estimate": str(pi_value)
        }
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "job_id": job_id,
            "pi_estimate": pi_value
        })
    }