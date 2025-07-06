variable "fe_tg_name" {
  description = "Name of the frontend target group"
  type        = string
}

variable "be_tg_name" {
  description = "Name of the backend target group"
  type        = string
}

variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the target groups will be created"
  type        = string
}