# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  version  = "1.32"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

# Define a managed EKS node group with scaling_config block
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = var.eks_nodegroup_role_arn
  subnet_ids      = aws_subnet.private[*].id
  instance_types  = ["t3.medium"]

  scaling_config {
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }

  ami_type = "AL2_x86_64"  
  disk_size = 20            
 
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}