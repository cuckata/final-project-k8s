# Configure the ECR repository (mutable)
resource "aws_ecr_repository" "docker" {
  name = "my-private-ecr"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}