terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "phoenix-dev-tfstate-111328751183"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "phoenix-dev-tfstate-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}