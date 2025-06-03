module "ecr-repository-fe" {
  source = "..//modules/ecr"

  name    = var.name
  project = var.project

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.ecr_kms_key.arn
}

module "s3-bucket-images" {
  source = "../modules/s3"

  s3_bucket_name = var.s3_bucket_name
  project         = var.project

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.s3_kms_key.arn
}