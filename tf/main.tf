terraform {
  backend "s3" { 
    region = "eu-central-1"
  }
}

# Set the provider
provider "aws" {
  region = var.aws_region
}