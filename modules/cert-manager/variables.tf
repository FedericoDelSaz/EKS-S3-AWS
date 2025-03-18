variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster Id"
}

variable "eks_oidc_issuer_url" {
  type        = string
  description = "The URL on the EKS cluster OIDC Issuer"
}

variable "aws_account_id" {
  type        = string
  description = "account id number"
}

variable "cert_manager_version" {
  type        = string
  description = "cert manager chart and images version"
}

variable "wait" {
  type        = bool
  default     = true
  description = "wait for successful installation of cert-manager helm chart"
}

variable "cluster_name" {
  description = "name of the cluster"
  type        = string
}
