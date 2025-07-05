module "ecr-repository-fe" {
  source = "..//modules/ecr"

  name    = var.name_fe
  project = var.project

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.ecr_kms_key.arn
}

module "ecr-repository-be" {
  source = "..//modules/ecr"

  name    = var.name_be
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

module "alb" {
  source = "../modules/alb"

  alb_sg_name        = var.alb_sg_name
  alb_sg_desc        = var.alb_sg_desc
  vpc_id             = var.vpc_id
  alb_name           = var.alb_name
  subnet_ids         = var.subnet_ids
  fe_tg_name         = var.fe_tg_name
  be_tg_name         = var.be_tg_name
  certificate_arn    = var.certificate_arn
  project            = var.project
}