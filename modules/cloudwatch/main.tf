resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = var.cloudwatch_name #"/ecs/my-fargate-service"
  retention_in_days = 7
}