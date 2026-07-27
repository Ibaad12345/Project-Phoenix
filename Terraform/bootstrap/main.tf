# Provider Setup
provider "aws" {
  region = "eu-west-2"
}

# Setting up S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "phoenix-dev-tfstate-111328751183"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "phoenix"
    Environment = "dev"
    Purpose     = "tfstate"
  }
}

# Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable Bucket Versioning
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block Public Access (Security Baseline)
resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Setting up DynamoDB State Lock Table
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "phoenix-dev-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "phoenix-dev-tfstate-locks"
    Environment = "dev"
    Purpose     = "tfstate-locks"
  }
}