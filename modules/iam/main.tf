
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