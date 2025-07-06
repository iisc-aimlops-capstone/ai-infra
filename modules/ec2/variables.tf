variable "ec2_sg_name" {
  description = "Name of the EC2 security group"
  type        = string
}
variable "ec2_sg_desc" {
  description = "Description of the EC2 security group"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be launched"
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
variable "project" {
  description = "Project name for tagging resources"
  type        = string
}