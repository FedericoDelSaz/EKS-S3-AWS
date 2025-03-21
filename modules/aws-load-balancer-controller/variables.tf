variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster Id"
}

variable "eks_oidc_issuer_url" {
  type        = string
  description = "The URL on the EKS cluster OIDC Issuer"
}

variable "cluster_name" {
  type = string
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC Provider if `enable_irsa = true`."
}

variable "helm_chart_version" {
  type        = string
  description = "Version of the AWS Load Balancer Controller Helm Chart"
  default     = "1.4.1"
}