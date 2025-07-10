variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
variable "project" {
  description = "Project name for tagging resources"
  type        = string
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for task execution"
  type        = string
}
variable "secret_name_arn" {
  description = "ARN of the AWS Secrets Manager secret for OpenAI API key"
  type        = string
}

