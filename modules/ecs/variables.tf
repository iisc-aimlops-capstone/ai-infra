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

variable "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
}

variable "ecs_task_execution_policy_name" {
  description = "Name of the ECS task execution policy"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}

variable "containerPort" {
  description = "Port on which the container listens"
  type        = number
}

variable "hostPort" {
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