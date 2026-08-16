# 1. Public Load Balancer Security Group
resource "aws_security_group" "alb" {
  name        = "phoenix-${var.environment}-alb-sg"
  description = "Controls traffic to public Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTPS from internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "phoenix-${var.environment}-alb-sg"
    Environment = var.environment
  }
}

# 2. Application Tier Security Group
resource "aws_security_group" "app" {
  name        = "phoenix-${var.environment}-app-sg"
  description = "Controls traffic to application instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow app traffic from ALB SG only"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "phoenix-${var.environment}-app-sg"
    Environment = var.environment
  }
}

# 3. Database Tier Security Group
resource "aws_security_group" "db" {
  name        = "phoenix-${var.environment}-db-sg"
  description = "Controls traffic to RDS / Database tier"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL access from App SG only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "No direct outbound internet allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "phoenix-${var.environment}-db-sg"
    Environment = var.environment
  }
}
