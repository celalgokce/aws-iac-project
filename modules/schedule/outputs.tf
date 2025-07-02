output "scheduler_role_arn" {
  description = "ARN of the scheduler IAM role"
  value       = aws_iam_role.ec2_scheduler_role.arn
}

output "stop_rule_arn" {
  description = "ARN of the stop rule"
  value       = var.enable_schedule ? aws_cloudwatch_event_rule.stop_ec2[0].arn : null
}

output "start_rule_arn" {
  description = "ARN of the start rule"
  value       = var.enable_schedule ? aws_cloudwatch_event_rule.start_ec2[0].arn : null
}

output "stop_lambda_arn" {
  description = "ARN of the stop Lambda function"
  value       = var.enable_schedule ? aws_lambda_function.ec2_stop[0].arn : null
}

output "start_lambda_arn" {
  description = "ARN of the start Lambda function"
  value       = var.enable_schedule ? aws_lambda_function.ec2_start[0].arn : null
}

output "schedule_enabled" {
  description = "Whether scheduling is enabled"
  value       = var.enable_schedule
}