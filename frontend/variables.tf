variable "name" {
  description = "The name of the ECR repository."
  type        = string
}

variable "project" {
  description = "The name of the project for tagging purposes."
  type        = string
}

variable "region" {
  description = "The AWS region where the ECR repository will be created."
  type        = string
  default     = "us-east-2"  # Default region, can be overridden
  
}

variable "ecs_sg_name" {
  description = "Name of the ECS security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ECS security group will be created"
  type        = string
}

variable "port" {
  description = "Port for the ECS service"
  type        = number
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

variable "ecr_image" {
  description = "ECR image URI for the ECS service"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to be created."
  type        = string
}