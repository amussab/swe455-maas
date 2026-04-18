import json
import os
import uuid
import boto3

events = boto3.client("events")

def lambda_handler(event, context):
    try:
        body = event.get("body") or "{}"
        if isinstance(body, str):
            body = json.loads(body)

        total_points = int(body.get("total_points", 1000))
        job_id = str(uuid.uuid4())
        event_bus_name = os.environ.get("EVENT_BUS_NAME", "default")

        events.put_events(
            Entries=[
                {
                    "Source": "pi.maas.api",
                    "DetailType": "PiEstimationRequested",
                    "Detail": json.dumps({
                        "job_id": job_id,
                        "total_points": total_points
                    }),
                    "EventBusName": event_bus_name
                }
            ]
        )

        return {
            "statusCode": 202,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Request accepted",
                "job_id": job_id,
                "total_points": total_points
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)})
        }