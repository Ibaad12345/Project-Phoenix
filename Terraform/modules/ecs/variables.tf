variable "environment" {
  description = "Deployment environment name (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources are deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnets for ECS tasks"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "app_security_group_id" {
  description = "Security Group ID for the ECS tasks"
  type        = string
}

variable "container_image" {
  description = "Docker container image to run"
  type        = string
  default     = "nginxdemos/hello"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "db_host" {
  description = "Database host endpoint"
  type        = string
  default     = ""
}