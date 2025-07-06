output "fe_target_group_arn" {
  value       = aws_lb_target_group.fe.arn
  description = "ARN of the target group"
}

output "be_target_group_arn" {
  value       = aws_lb_target_group.be.arn
  description = "ARN of the target group"
}