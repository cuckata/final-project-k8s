# Output the ECR repository URL
output "ecr_repository_url" {
  value       = aws_ecr_repository.docker.repository_url
  description = "The ECR repository URL"
}

# Output the EKS cluster endpoint
output "cluster_endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "The EKS cluster endpoint"
}