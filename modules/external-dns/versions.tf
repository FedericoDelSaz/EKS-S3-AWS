terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">=5.26.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.16.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.30.0"
    }
  }
  required_version = ">= 1.0"
}
