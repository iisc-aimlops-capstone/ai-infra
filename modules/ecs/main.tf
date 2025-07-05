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

resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.ecs_cluster_name

    tags = {
        Name        = var.ecs_cluster_name
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

resource "aws_iam_role" "ecs_task_execution" {
    name = "${var.ecs_cluster_name}-task-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name        = "${var.ecs_cluster_name}-task-execution-role"
        CreatedBy   = "Terraform"
        Project     = var.project
    }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
    role       = aws_iam_role.ecs_task_execution.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_execution_s3_fullaccess" {
    name        = "${var.ecs_cluster_name}-task-execution-s3-putobject"
    description = "Allow ECS task execution role to put objects in S3"
    policy      = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Action = [
            "s3:*"
            ]
            Resource = [
                "arn:aws:s3:::${var.s3_bucket_name}",
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ]
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_s3_fullaccess" {
    role       = aws_iam_role.ecs_task_execution.name
    policy_arn = aws_iam_policy.ecs_task_execution_s3_fullaccess.arn
}

resource "aws_ecs_task_definition" "task_def" {
    family                   = "${var.ecs_cluster_name}-task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                     = "256"
    memory                  = "512"
    execution_role_arn      = aws_iam_role.ecs_task_execution.arn
    task_role_arn = aws_iam_role.ecs_task_execution.arn
    container_definitions = jsonencode([
        {
            name = "${var.ecs_cluster_name}-container"
            image = var.ecr_image
            essential = true
            portMappings = [
                {
                    containerPort = var.containerPort
                    hostPort      = var.hostPort
                    protocol      = "tcp"
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "svc" {
    name = "${var.ecs_cluster_name}-service"
    cluster = aws_ecs_cluster.ecs_cluster.id
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