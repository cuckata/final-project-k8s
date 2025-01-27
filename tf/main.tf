terraform {
  backend "s3" {
    
  }
}

# Set the provider
provider "aws" {
  region = var.aws_region
}