variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)"
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}