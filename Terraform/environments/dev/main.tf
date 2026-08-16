# 1. Base VPC Networking Module
module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# 2. Security Groups Module
module "security" {
  source = "../../modules/security"

  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

# 3. RDS Database Module
module "rds" {
  source = "../../modules/rds"

  environment          = var.environment
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.security.db_security_group_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}

# 4. ECS & Load Balancer Module
module "ecs" {
  source = "../../modules/ecs"

  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id
  container_image       = var.container_image
  container_port        = var.container_port
  db_host               = module.rds.db_endpoint
}