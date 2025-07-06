variable "name_fe" {
  description = "The name of the ECR repository."
  type        = string
}

variable "name_be" {
  description = "The name of the backend ECR repository."
  type        = string
}

variable "project" {
  description = "The name of the project for tagging purposes."
  type        = string
}

variable "region" {
  description = "The AWS region where the ECR repository will be created."
  type        = string
  default     = "us-east-2" # Default region, can be overridden

}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to be created."
  type        = string
}

variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
}

variable "alb_sg_desc" {
  description = "Description of the ALB security group"
  type        = string
  default     = "Security group for ALB"
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "fe_tg_name" {
  description = "Name of the frontend target group"
  type        = string
}

variable "be_tg_name" {
  description = "Name of the backend target group"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string

}
variable "ecs_sg_name_fe" {
  description = "Name of the ECS security group for frontend"
  type        = string
}
variable "ecs_sg_desc_fe" {
  description = "Description of the ECS security group for frontend"
  type        = string
}
variable "ecs_sg_name_be" {
  description = "Name of the ECS security group for backend"
  type        = string
}
variable "ecs_sg_desc_be" {
  description = "Description of the ECS security group for backend"
  type        = string
}
variable "ecr_image_fe" {
  description = "ECR image URI for the frontend ECS task"
  type        = string
}
variable "ecr_image_be" {
  description = "ECR image URI for the backend ECS task"
  type        = string
}

variable "ec2_sg_name" {
  description = "Name of the EC2 security group"
  type        = string
}

variable "ec2_sg_desc" {
  description = "Description of the EC2 security group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}


variable "secret_name" {
  description = "Name of the AWS Secrets Manager secret"
  type        = string
}