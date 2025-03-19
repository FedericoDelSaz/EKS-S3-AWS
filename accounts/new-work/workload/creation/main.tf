module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.0"
  cluster_name    = var.cluster_name
  cluster_version = local.cluster_version
  subnet_ids      = local.private_eks_subnets
  vpc_id          = data.aws_vpc.eks.id
  create_kms_key  = false
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
  kms_key_enable_default_policy = false

  authentication_mode = "API_AND_CONFIG_MAP"
  access_entries = {
    cluster_admin = {
      principal_arn = "arn:aws:iam::${local.aws_account_id}:user/${local.user}"
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  # allow traffic from local VPC to Cluster on 443
  cluster_security_group_additional_rules = {
    inress_ec2_tcp = {
      description = "Access EKS from EC2 instance."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [local.cidr_block]
    }
  }
}

# Use the aws-auth module to associate IAM roles with Kubernetes RBAC roles
module "aws_auth" {
  source                    = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version                   = "20.24.0"
  manage_aws_auth_configmap = true
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.user}"
      username = local.user
      groups   = ["system:masters"]
    }
  ]
  aws_auth_roles = concat(
    [
      for eks_node_group in module.eks.eks_managed_node_groups :
      {
        rolearn  = eks_node_group.iam_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ]
  )

  aws_auth_accounts = [
    local.aws_account_id
  ]
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

module "eks_s3_csi_driver" {
  source  = "../../../../modules/aws-s3-csi-driver"

  environment = "dev"
  eks_cluster_name = var.cluster_name
  bucket_name = "s3-bucket-${random_id.bucket_id.hex}"
}

module "s3_app_test" {
  source = "../../../../modules/s3-app-test"
  namespace = var.namespace
  bucket_name = "s3-bucket-${random_id.bucket_id.hex}"
  app_s3_enabled = false
  depends_on = [module.eks_s3_csi_driver]
}

#module "render_image_app" {
#  source = "../../../../modules/s3-app-test/render-image-app"
#  bucket_name = "s3-bucket-${random_id.bucket_id.hex}"
#  namespace   = var.namespace
#  depends_on = [module.s3_app_test]
#}

module "cert_manager" {
  source = "../../../../modules/cert-manager"
  aws_account_id = data.aws_caller_identity.current.account_id
  cert_manager_version = local.cert_manager_version
  eks_cluster_id = local.eks_cluster_id
  eks_oidc_issuer_url = local.eks_oidc_issuer_url
  cluster_name = var.cluster_name
}