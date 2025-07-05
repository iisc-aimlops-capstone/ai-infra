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

variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

