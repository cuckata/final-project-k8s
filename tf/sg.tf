# Security Group for EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-control-plane-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = aws_vpc.eks_vpc.id

# Inbound Rules
  ingress {
    description = "Allow HTTPS traffic from worker nodes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

#Outbound Rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Internal Load Balancer
resource "aws_security_group" "internal_lb_sg" {
  name        = "internal-lb-sg"
  description = "Internal Load Balancer Security Group"
  vpc_id      = aws_vpc.eks_vpc.id

  # Inbound Rules
  ingress {
    description = "Allow HTTP traffic from worker nodes"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic from worker nodes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}