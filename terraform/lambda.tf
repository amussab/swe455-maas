resource "aws_lambda_function" "api_lambda" {
  function_name = "swe455-api-lambda"
  package_type  = "Image"
  image_uri     = "971247112713.dkr.ecr.us-east-1.amazonaws.com/swe455-api:latest"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 30

  environment {
    variables = {
      EVENT_BUS_NAME = "default"
    }
  }
}

resource "aws_lambda_function" "simulation_lambda" {
  function_name = "swe455-simulation-lambda"
  package_type  = "Image"
  image_uri     = "971247112713.dkr.ecr.us-east-1.amazonaws.com/swe455-simulation:latest"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 300
  memory_size   = 1024

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.results.name
    }
  }
}
