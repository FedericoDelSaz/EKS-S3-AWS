data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

data "aws_subnets" "eks_private_subnets" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  filter {
    name   = "tag:Name"
    values = ["private-eks-*"]
  }
}

data "aws_subnets" "eks_private_subnets_eu_central_1b" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  filter {
    name   = "tag:Name"
    values = ["private-eks-eu-west-1b"]
  }
}

data "aws_vpc" "eks" {
  filter {
    name   = "tag:Name"
    values = ["eks-vpc"]
  }
}

data "aws_kms_key" "new_work_kms_key" {
  key_id = "alias/workload-new-work"
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}