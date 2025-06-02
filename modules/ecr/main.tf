resource "aws_ecr_repository" "my_ecr_repo" {
  name = var.name

  encryption_configuration {
    encryption_type = "AES256"  # Options: "AES256" (default), "KMS"
    # Uncomment the following line to use a customer-managed KMS key
    # kms_key = aws_kms_key.ecr_kms_key.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = var.name
    CreatedBy   = "Terraform"
    Project     = var.project
  }
}