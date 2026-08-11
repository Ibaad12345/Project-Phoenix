variable "aws_region" {
  description = "The AWS region where dev resources will be deployed"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the Dev VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs to deploy subnets into for high availability"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}



variable "db_name" {
  description = "The name of the initial database to create"
  type        = string
  default     = "phoenixdb"
}

variable "db_username" {
  description = "Master username for the RDS database"
  type        = string
  default     = "phoenix_admin"
}

variable "db_password" {
  description = "Master password for the RDS database"
  type        = string
  sensitive   = true
}

variable "container_image" {
  description = "Docker image to deploy in Fargate"
  type        = string
  default     = "nginxdemos/hello" # Lightweight test image that exposes HTTP port 80
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}