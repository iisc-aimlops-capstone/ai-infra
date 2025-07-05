output "target_group_arn_fe" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.fe.arn
}
output "target_group_arn_be" {
  description = "ARN of the backend target group"
  value       = aws_lb_target_group.be.arn
}