data "aws_caller_identity" "current" {}

# Data sources to get EKS cluster details

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}