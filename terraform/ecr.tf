resource "aws_ecr_repository" "api_repo" {
  name = "swe455-api"
}

resource "aws_ecr_repository" "simulation_repo" {
  name = "swe455-simulation"
}
