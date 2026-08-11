# 1. CloudWatch Log Group for Container Logs
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/phoenix-dev-app"
  retention_in_days = 7

  tags = {
    Name        = "phoenix-dev-ecs-logs"
    Environment = "dev"
  }
}

# 2. ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "phoenix-dev-cluster"

  tags = {
    Name        = "phoenix-dev-cluster"
    Environment = "dev"
  }
}

# 3. Fargate Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "phoenix-dev-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU (Cost-effective for dev)
  memory                   = "512" # 512 
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "phoenix-app"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.postgres.endpoint
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_username
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])

  tags = {
    Name        = "phoenix-dev-task-def"
    Environment = "dev"
  }
}

# 4. ECS Service (Deploys container tasks into Private Subnets)
resource "aws_ecs_service" "app" {
  name            = "phoenix-dev-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2 # Ensures High Availability across 2 AZs
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false # Secure: Kept inside private subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "phoenix-app"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition] # Allows future CI/CD pipelines to update task versions without Terraform drift
  }

  tags = {
    Name        = "phoenix-dev-ecs-service"
    Environment = "dev"
  }
}

