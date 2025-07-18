resource "aws_security_group" "ecs_sg" {
    name        = var.ecs_sg_name
    description = var.ecs_sg_desc
    vpc_id      = var.vpc_id

    ingress {
        from_port   = var.from_port
        to_port     = var.to_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.ecs_sg_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

/* data "aws_secretsmanager_secret" "openai" {
  name = var.secret_name  # Replace with your secret name
} */


resource "aws_ecs_task_definition" "task_def" {
    family                   = var.ecs_task_definition_name
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                     = var.cpu #"1024"
    memory                  = var.memory #"2048"
    execution_role_arn      = var.ecs_task_execution_role_arn
    task_role_arn = var.ecs_task_execution_role_arn
    container_definitions = jsonencode([
        {
            name = var.ecs_container_name
            image = var.ecr_image
            essential = true
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group         = var.cloudwatch_name
                    awslogs-region        = "us-east-2" # change based on region
                    awslogs-stream-prefix = "ecs"
                }
            }
            portMappings = [
                {
                    containerPort = var.port
                    hostPort      = var.port
                    protocol      = "tcp"
                }
            ]
            environment = []
            secrets = [
              {
                name      = "OPENAI_API_KEY"
                valueFrom = var.secret_name_arn
              },
              {
                name      = "GEMINI_API_KEY"
                valueFrom = var.gemini_secret_name_arn
              }
            ]
        }
    ])
}


/*
data "aws_ecs_cluster" "ai_cluster" {
  cluster_name = var.ecs_cluster_name
}

resource "aws_ecs_service" "svc" {
    name = "${var.ecs_cluster_name}-service"
    cluster = data.aws_ecs_cluster.ai_cluster.id
    task_definition = aws_ecs_task_definition.task_def.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets          = var.subnet_ids
        security_groups  = [aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = var.tg_arn
        container_name   = "${var.ecs_cluster_name}-container"
        container_port   = var.containerPort
    }
    lifecycle {
        ignore_changes = [
            task_definition,  # Ignore changes to task definition to avoid unnecessary updates
        ]
    }
    depends_on = [ aws_iam_role_policy_attachment.ecs_task_execution_policy ]
}

*/