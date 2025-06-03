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

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to be created."
  type        = string
}