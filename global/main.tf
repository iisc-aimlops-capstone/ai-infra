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
  project        = var.project

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.s3_kms_key.arn
}
/*
module "ec2-instance" {
  source = "../modules/ec2"

  ec2_sg_name       = var.ec2_sg_name
  ec2_sg_desc       = var.ec2_sg_desc
  vpc_id            = var.vpc_id
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  ec2_instance_name = var.ec2_instance_name
  project           = var.project
}
*/
module "target_group" {
  source = "../modules/target_group"

  fe_tg_name = var.fe_tg_name
  be_tg_name = var.be_tg_name
  vpc_id     = var.vpc_id
  project    = var.project

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.target_group_kms_key.arn
}

module "cloudwatch_logs_fe" {
  source = "../modules/cloudwatch"

  cloudwatch_name = var.cloudwatch_loggroup_name_fe

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.cloudwatch_kms_key.arn
}

module "cloudwatch_logs_be" {
  source = "../modules/cloudwatch"

  cloudwatch_name = var.cloudwatch_loggroup_name_be

  # Uncomment the following line to use a customer-managed KMS key
  # kms_key_arn = aws_kms_key.cloudwatch_kms_key.arn
}

module "alb" {
  source = "../modules/alb"

  alb_sg_name        = var.alb_sg_name
  alb_sg_desc        = var.alb_sg_desc
  vpc_id             = var.vpc_id
  alb_name           = var.alb_name
  subnet_ids         = var.subnet_ids
  fe_tg_arn         = module.target_group.fe_target_group_arn
  be_tg_arn         = module.target_group.be_target_group_arn
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
  s3_bucket_name   = module.s3-bucket-images.s3_bucket_name
  secret_name_arn =   var.secret_name_arn
  gemini_secret_name_arn = var.gemini_secret_name_arn
  # Uncomment the following lines to use customer-managed KMS keys
  # kms_key_arn = aws_kms_key.ecs_kms_key.arn
  # kms_key_policy = aws_kms_key_policy.ecs_kms_key_policy.json
}

module "ecs-service-fe" {
  source                      = "../modules/ecs-service"
  ecs_sg_name                 = var.ecs_sg_name_fe
  ecs_sg_desc                 = var.ecs_sg_desc_fe
  vpc_id                      = var.vpc_id
  from_port                   = 8501
  to_port                     = 8501
  port                        = 8501
  project                     = var.project
  ecs_cluster_name            = var.ecs_cluster_name
  subnet_ids                  = var.subnet_ids
  ecr_image                   = var.ecr_image_fe
  s3_bucket_name              = module.s3-bucket-images.s3_bucket_name
  tg_arn                      = module.target_group.fe_target_group_arn
  ecs_task_execution_role_arn = module.ecs-iam_roles.iam_role_arn
  ecs_task_definition_name    = "${var.ecs_cluster_name}-task-fe"
  ecs_container_name          = "${var.ecs_cluster_name}-container-fe"
  secret_name_arn                 = var.secret_name_arn
  gemini_secret_name_arn          = var.gemini_secret_name_arn
  cloudwatch_name             = var.cloudwatch_loggroup_name_fe
  cpu                         = "1024"  # Adjust CPU as needed
  memory                      = "2048"  # Adjust memory as needed
}

module "ecs-service-be" {
  source                      = "../modules/ecs-service"
  ecs_sg_name                 = var.ecs_sg_name_be
  ecs_sg_desc                 = var.ecs_sg_desc_be
  vpc_id                      = var.vpc_id
  from_port                   = 8000
  to_port                     = 8000
  port                        = 8000
  project                     = var.project
  ecs_cluster_name            = var.ecs_cluster_name
  subnet_ids                  = var.subnet_ids
  ecr_image                   = var.ecr_image_be
  s3_bucket_name              = module.s3-bucket-images.s3_bucket_name
  tg_arn                      = module.target_group.be_target_group_arn
  ecs_task_execution_role_arn = module.ecs-iam_roles.iam_role_arn
  ecs_task_definition_name    = "${var.ecs_cluster_name}-task-be"
  ecs_container_name          = "${var.ecs_cluster_name}-container-be"
  secret_name_arn                 = var.secret_name_arn
  gemini_secret_name_arn          = var.gemini_secret_name_arn
  cloudwatch_name             = var.cloudwatch_loggroup_name_be
  cpu                         = "1024"  # Adjust CPU as needed
  memory                      = "2048"  # Adjust memory as needed
}
