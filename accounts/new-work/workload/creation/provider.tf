provider "aws" {
  region     = "eu-west-1"
  access_key = ""
  secret_key = ""
  profile    = "new-work-se-user"

  default_tags {
    tags = {
      "created_by" = "Terraform"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}