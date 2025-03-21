data "aws_caller_identity" "current" {}

# Data sources to get EKS cluster details

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

data "aws_vpc" "eks" {
  filter {
    name   = "tag:Name"
    values = ["eks-vpc"]
  }
}

data "aws_subnets" "eks_public_subnets" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  filter {
    name   = "tag:Name"
    values = ["public-eks-*"]
  }
}