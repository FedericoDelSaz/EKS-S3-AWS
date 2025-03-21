locals {
  cert_manager_version = "v1.12.3"
  public_domain        = "new-work-se-test.com"
  vpc_id = data.aws_vpc.eks.id
  vpc_name = data.aws_vpc.eks
  public_eks_subnets = length(data.aws_subnets.eks_public_subnets.ids) > 0 ? data.aws_subnets.eks_public_subnets.ids : []
}