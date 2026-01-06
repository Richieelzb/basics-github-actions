resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/lzb-service"
  retention_in_days = 7
}