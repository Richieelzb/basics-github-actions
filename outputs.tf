
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

/*output "sns_topic_arn" {
  value = aws_sns_topic.lzb-project-sns.arn
}*/

output "ecr_repo_url" {
  value = aws_ecr_repository.lzb-project.repository_url
}
