# AWS Region for the provider
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

# Backend configuration variables
variable "backend_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "backend_key" {
  description = "Path to store Terraform state within the S3 bucket"
  type        = string
}

variable "backend_region" {
  description = "Region for the S3 bucket and DynamoDB table"
  type        = string
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet CIDR blocks for private subnets
variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Subnet CIDR blocks for public subnets
variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# variable for cluster role ARN
variable "eks_cluster_role_arn" {
  description = "ARN for the EKS cluster role"
  type        = string
}

# variable for nodegroup role ARN
variable "eks_nodegroup_role_arn" {
  description = "ARN for the EKS nodegroup role"
  type        = string
}

# variable for ELB role ARN
variable "elb_role_arn" {
  description = "ARN for the Elastic Load Balancer role"
  type        = string
}

# variable for autoscaling role ARN
variable "autoscaling_role_arn" {
  description = "ARN for the AutoScaling role"
  type        = string
}