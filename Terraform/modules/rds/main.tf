# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name        = "phoenix-${var.environment}-db-subnet-group"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name        = "phoenix-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier             = "phoenix-${var.environment}-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp3"

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group_id]

  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name        = "phoenix-${var.environment}-db"
    Environment = var.environment
  }
}