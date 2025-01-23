#config the terraform backend to use S3 for the tfstate
terraform {
  backend "s3" {
    bucket = "my-terraform-state-cecko" # S3 bucket name
    key = "myproject/prod/terraform.tfstate" # Path withing the bucket
    region = "eu-central-1" # AWS Region
    dynamodb_table = "terraform-locks" # DynamoDB table for the state locking
    encrypt = true # Bucket encryption enabled, so state file is encrypted
  }
}

#set the provider
provider "aws" {
  region = "eu-central-1"
}

#configure the resource, in this case its Elastic Container Repository (ECR) which is Mutable (allow overwriting existing images)
resource "aws_ecr_repository" "docker" {
  name = "my-private-ecr"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true #scans the images for vulnerabilities on push
  }

  tags = {
    Environment = "prod"
    ManagedBy = "terraform"
  }
}

#outputs in the terminal the URL of the ECR repo
output "ecr_repository_URL" {
  value = aws_ecr_repository.docker.repository_url
  description = "The ECR repo URL"
}

#create a VPC for the EKS cluster using a module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  tags = {
    "Name" = "eks-vpc"
  }
}

#create the EKS cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name = "my-eks-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  subnet_ids = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    instance_types = ["t2.micro"]
  }
  eks_managed_node_groups = {
    eks_nodes = {
      instance_types = ["t2.micro"]

      min_size = 1
      max_size = 3
      desired_size = 2
    }
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
