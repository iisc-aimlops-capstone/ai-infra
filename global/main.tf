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

module "ecs-cluster" {
  source = "../modules/ecs-cluster"

  ecs_cluster_name = var.ecs_cluster_name
  project          = var.project
}

module "ecs-iam_roles" {
  source = "../modules/iam"

  ecs_cluster_name = var.ecs_cluster_name
  project          = var.project
  s3_bucket_name = module.s3-bucket-images.s3_bucket_name
  # Uncomment the following lines to use customer-managed KMS keys
  # kms_key_arn = aws_kms_key.ecs_kms_key.arn
  # kms_key_policy = aws_kms_key_policy.ecs_kms_key_policy.json
}

module "ecs-service-fe" {
  source = "../modules/ecs-service"
  ecs_sg_name                   = var.ecs_sg_name_fe
  ecs_sg_desc                   = var.ecs_sg_desc_fe
  vpc_id                        = var.vpc_id
  from_port                     = 8501
  to_port                       = 8501
  containerPort                 = 8501
  hostPort                      = 8501
  project                       = var.project
  ecs_cluster_name              = var.ecs_cluster_name
  subnet_ids                    = var.subnet_ids
  ecr_image                     = var.ecr_image_fe
  s3_bucket_name                = module.s3-bucket-images.s3_bucket_name
  tg_arn                        = module.alb.target_group_arn_fe
  ecs_task_execution_role_arn   = module.ecs-iam_roles.iam_role_arn
  ecs_task_definition_name      = "${var.ecs_cluster_name}-task-fe"
  ecs_container_name            = "${var.ecs_cluster_name}-container-fe"
}

module "ecs-service-be" {
  source = "../modules/ecs-service"
  ecs_sg_name                   = var.ecs_sg_name_be
  ecs_sg_desc                   = var.ecs_sg_desc_be
  vpc_id                        = var.vpc_id
  from_port                     = 8000
  to_port                       = 8000
  containerPort                 = 8000
  hostPort                      = 8000
  project                       = var.project
  ecs_cluster_name              = var.ecs_cluster_name
  subnet_ids                    = var.subnet_ids
  ecr_image                     = var.ecr_image_be
  s3_bucket_name                = module.s3-bucket-images.s3_bucket_name
  tg_arn                        = module.alb.target_group_arn_be
  ecs_task_execution_role_arn   = module.ecs-iam_roles.iam_role_arn
  ecs_task_definition_name      = "${var.ecs_cluster_name}-task-be"
  ecs_container_name            = "${var.ecs_cluster_name}-container-be"
}