locals {
  cluster_version = "1.32"
  aws_account_id  = data.aws_caller_identity.current.account_id
  eks_cluster_id        = data.aws_eks_cluster.eks.id
  eks_oidc_issuer_url   = replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")
  eks_oidc_provider_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_issuer_url}"

  # VPC CIDR block for allowing traffic
  cidr_block = "10.0.0.0/16"

  # Make sure that private subnets are defined and available
  private_eks_subnets = length(data.aws_subnets.eks_private_subnets.ids) > 0 ? data.aws_subnets.eks_private_subnets.ids : []

  # User and role definition for IAM
  user = "interview-candidate"
  role = "AWSServiceRoleForAmazonEKS"  # Make sure this role exists

  # Managed node group configuration
  eks_managed_node_groups = {
    worker_nodes_1_32 = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium", "t3.large"]
      capacity_type  = "ON_DEMAND"
      k8s_labels     = {}
      additional_tags = {
        "core:solution"      = "kubernetes_nodes"
        "core:eks_nodegroup" = "worker_1_32"
        "StackName"          = "eks_${var.cluster_name}"
        "Purpose"            = "eks_nodegroup_worker_1_32"
      }
      taints = []
      update_config = {
        max_unavailable = 1
      }
      create_security_group                 = false
      attach_cluster_primary_security_group = true
    }
  }
}