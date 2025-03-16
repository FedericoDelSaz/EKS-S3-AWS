# EKS Cluster Creation using terraform-aws-modules/eks/aws
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.0"
  cluster_name    = var.cluster_name
  cluster_version = local.cluster_version  # EKS version 1.32
  subnet_ids      = local.private_eks_subnets
  vpc_id          = data.aws_vpc.eks.id
  create_kms_key             = false
  # Enable IAM roles for service accounts (IRSA) for secure access to S3
  enable_irsa                = true
  create_node_security_group = false

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_encryption_config = {
    provider_key_arn = data.aws_kms_key.new_work_kms_key.arn
    resources        = ["secrets"]
  }

  cluster_addons = {
    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        replicaCount = 3
      })
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }

  }

  eks_managed_node_groups       = local.eks_managed_node_groups

}

# Use the aws-auth module to associate IAM roles with Kubernetes RBAC roles
module "aws_auth" {
  source          = "terraform-aws-modules/eks/aws//modules/aws-auth"
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/platform-admin"  # Replace with the IAM role ARN
      username = "platform-admin"
      groups   = ["system:masters"]  # Example group; you can adjust as needed
    }
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.role_admin}"  # Replace with IAM user ARN
      username = local.role_admin
      groups   = ["system:masters"]
    }
  ]
  aws_auth_accounts = [
    var.aws_account_id # Example AWS Account ID; you can add additional account IDs as needed
  ]
}