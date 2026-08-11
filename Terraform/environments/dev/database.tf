# 1. DB Subnet Group (Binds database to our private subnets across 2 AZs)
resource "aws_db_subnet_group" "main" {
  name       = "phoenix-dev-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "phoenix-dev-db-subnet-group"
    Environment = "dev"
  }
}

# 2. RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier            = "phoenix-dev-db"
  allocated_storage     = 20
  max_allocated_storage = 50 # Allows storage autoscaling up to 50 GB
  engine                = "postgres"
  engine_version        = "15"
  instance_class        = "db.t4g.micro" # AWS Graviton2 cost-effective free-tier/dev class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  # Resilience & Maintenance
  multi_az            = false # Set to true for production high availability
  publicly_accessible = false # Keeps DB isolated inside private subnets
  skip_final_snapshot = true  # Speeds up teardown in dev environments
  storage_encrypted   = true

  tags = {
    Name        = "phoenix-dev-postgres"
    Environment = "dev"
  }
}