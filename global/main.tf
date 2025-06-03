module "ecr-repository-fe" {
  source = "..//modules/ecr"

  name    = var.name
  project = var.project

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.ecr_kms_key.arn
}
