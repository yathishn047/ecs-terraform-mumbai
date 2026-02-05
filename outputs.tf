output "ecs_cluster_id" {
  description = "ECS cluster id"
  value       = aws_ecs_cluster.mumbai.id
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.mumbai_queue.url
}

output "sqs_queue_arn" {
  description = "SQS queue ARN"
  value       = aws_sqs_queue.mumbai_queue.arn
}