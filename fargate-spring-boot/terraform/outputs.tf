output "ecr_repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "ECR repository URL (registry/repo)"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "ECS cluster name"
}

output "execution_role_arn" {
  value       = aws_iam_role.task_execution.arn
  description = "Task execution role ARN"
}

output "task_role_arn" {
  value       = aws_iam_role.task_role.arn
  description = "Task role ARN"
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.ecs.name
  description = "CloudWatch log group name for ECS tasks"
}

output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "ALB DNS name"
}

