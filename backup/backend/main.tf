data "aws_lb_target_group" "fastapi_tg" {
  name = "tg-iisc-aimlops-cap-be"
}

module "ecs-be" {
  source = "../modules/ecs_service"
  ecs_sg_name                   = var.ecs_sg_name
  ecs_sg_desc                   = var.ecs_sg_name
  vpc_id                        = var.vpc_id
  from_port                     = var.port
  to_port                       = var.port
  containerPort                 = var.port
  hostPort                      = var.port
  project                       = var.project
  ecs_cluster_name              = var.ecs_cluster_name
  ecs_task_execution_role_name  = var.ecs_task_execution_role_name
  ecs_task_execution_policy_name = var.ecs_task_execution_policy_name
  subnet_ids                    = var.subnet_ids
  ecr_image                    = var.ecr_image
  s3_bucket_name              = var.s3_bucket_name
  tg_arn                        = data.aws_lb_target_group.fastapi_tg.arn
}