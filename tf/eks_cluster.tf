# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  version  = "1.32"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
}

# Define an EKS node group with scaling_config block
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = var.eks_nodegroup_role_arn
  subnet_ids      = aws_subnet.private[*].id
  instance_types  = ["t2.micro"]

  scaling_config {
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

# Create an IAM role for Elastic Load Balancing
resource "aws_iam_role_policy_attachment" "elb_policy_attachment" {
  role       = var.elb_role_arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Attach IAM role for Auto Scaling
resource "aws_iam_role_policy_attachment" "autoscaling_policy_attachment" {
  role       = var.autoscaling_role_arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}