data "aws_caller_identity" "current" {}

# Reference the existing network resources from the S3 backend (network-creation.tfstate)
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "network-creation"         # S3 bucket where the network state is stored
    key     = "network-creation.tfstate" # Path to the state file in the bucket
    region  = "eu-west-1"                # Region where the S3 bucket is located
    profile = "new-work-se-user"         # Profile used for accessing the state
    encrypt = true                       # Optional, ensures the state file is encrypted in S3
  }
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

#data "aws_vpc" "eks" {
#  cidr_block = var.cidr_block
#  state      = "available"
#}

data "aws_vpc" "eks" {
  filter {
    name   = "tag:Name"
    values = ["eks-vpc"] # Replace with your VPC tag name
  }
}

data "aws_kms_key" "new_work_kms_key" {
  key_id = "alias/workload-new-work"
}

data "aws_ecr_authorization_token" "token" {
}