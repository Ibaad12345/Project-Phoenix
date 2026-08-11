aws_region           = "eu-west-2"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["eu-west-2a", "eu-west-2b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]


db_name     = "phoenixdb"
db_username = "phoenix_admin"
db_password = "SuperSecretPassword123!" 