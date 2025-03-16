# Attach policies to EKS Node Group IAM role
resource "aws_iam_role_policy_attachment" "eks_node_group_role_policy" {
  role       = data.terraform_remote_state.workload_creation.outputs.eks_node_group_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_s3_policy" {
  role       = data.terraform_remote_state.workload_creation.outputs.eks_node_group_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create EKS Managed Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = data.terraform_remote_state.workload_creation.outputs.eks_cluster_name
  node_group_name = "eks-node-group"
  node_role_arn   = data.terraform_remote_state.workload_creation.outputs.eks_node_group_role
  subnet_ids      = data.terraform_remote_state.workload_creation.outputs.subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]
}

# Output EKS Node Group Details
output "eks_node_group_name" {
  value = aws_eks_node_group.eks_node_group.node_group_name
}

# Backend Configuration for this stage
terraform {
  backend "s3" {
    bucket  = "workload-configuration"
    key     = "workload-configuration.tfstate"
    region  = "eu-west-1"
    profile = "new-work-se-user"
    encrypt = true
  }
}
