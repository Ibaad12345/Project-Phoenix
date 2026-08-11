# 1. IAM Role for ECS Task Execution (Used by AWS to pull images & manage logging)
resource "aws_iam_role" "ecs_execution_role" {
  name = "phoenix-dev-ecs-execution-role"

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
    Name        = "phoenix-dev-ecs-execution-role"
    Environment = "dev"
  }
}

# 2. Attach Standard AWS Managed Policy for Task Execution
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 3. IAM Role for the Running Application Task (Used by your application code if accessing AWS services)
resource "aws_iam_role" "ecs_task_role" {
  name = "phoenix-dev-ecs-task-role"

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
    Name        = "phoenix-dev-ecs-task-role"
    Environment = "dev"
  }
}