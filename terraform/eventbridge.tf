resource "aws_cloudwatch_event_rule" "simulation_rule" {
  name = "swe455-simulation-rule"

  event_pattern = jsonencode({
    source      = ["pi.maas.api"]
    detail-type = ["PiEstimationRequested"]
  })
}

resource "aws_cloudwatch_event_target" "simulation_target" {
  rule      = aws_cloudwatch_event_rule.simulation_rule.name
  target_id = "SimulationLambdaTarget"
  arn       = aws_lambda_function.simulation_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.simulation_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.simulation_rule.arn
}