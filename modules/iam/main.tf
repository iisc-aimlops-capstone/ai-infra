
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

data "aws_secretsmanager_secret" "openai" {
  name = var.secret_name  # Replace with your secret name
}


resource "aws_iam_policy" "secrets_access_policy" {
  name        = "${var.ecs_cluster_name}-SecretsAccessPolicy"
  description = "Allow ECS Task to access OpenAI secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = data.aws_secretsmanager_secret.openai.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secrets_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}


resource "aws_iam_policy" "ecs_cloudwatch_logs_policy" {
  name        = "${var.ecs_cluster_name}-ECSCloudWatchLogsPolicy"
  description = "Policy to allow ECS tasks to create log streams and put log events in CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:log-group:/ecs/*:log-stream:*"
      },
      {
        Effect = "Allow",
        Action = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:*:*:log-group:/ecs/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_cloudwatch_logs_policy.arn
}