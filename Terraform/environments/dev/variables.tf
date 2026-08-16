variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Target deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "container_port" {
  description = "Application container port"
  type        = number
  default     = 80
}

variable "container_image" {
  description = "Application container image"
  type        = string
  default     = "nginxdemos/hello"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "phoenixdb"
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}