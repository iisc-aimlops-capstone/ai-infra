variable "ecs_sg_name" {
  description = "Name of the ECS security group"
  type        = string
}

variable "ecs_sg_desc" {
  description = "Description of the ECS security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ECS security group will be created"
  type        = string
}

variable "from_port" {
  description = "Starting port for the ingress rule"
  type        = number
}

variable "to_port" {
  description = "Ending port for the ingress rule"
  type        = number
}

variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}



variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}


variable "port" {
    description = "Port on which the host listens"
    type        = number
}

variable "ecr_image" {
  description = "ECR image URI for the ECS task"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for task execution"
  type        = string
}

variable "tg_arn" {
  description = "arn of the ECS target group"
  type        = string
  default     = null
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}
variable "ecs_task_definition_name" {
  description = "Name of the ECS task execution role"
  type        = string
}
variable "ecs_container_name" {
  description = "Name of the ECS container"
  type        = string
}

variable "secret_name_arn" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
}

variable "cloudwatch_name" {
  description = "The name of the CloudWatch log group"
  type        = string
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory in MiB for the ECS task"
  type        = string
  default     = "512"
}

variable "gemini_secret_name_arn" {
  description = "ARN of the AWS Secrets Manager secret for Gemini API key"
  type        = string
}