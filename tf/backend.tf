#configure terraform backend to use S3 to keep the tfstate file
terraform {
  backend "s3" {
    bucket         = var.backend_bucket         # S3 bucket name
    key            = var.backend_key            # Path within the bucket
    region         = var.backend_region         # AWS Region
    dynamodb_table = var.backend_dynamodb_table # DynamoDB table for state locking
    encrypt        = true                       # Bucket encryption enabled, so state file is encrypted
  }
}