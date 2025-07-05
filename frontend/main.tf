module "ecs-fe" {
  source = "../modules/ecs"
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
  tg_arn                        = var.tg_arn
}