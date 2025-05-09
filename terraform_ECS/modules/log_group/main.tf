resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.repository_name}"
  retention_in_days = var.retention_in_days
}