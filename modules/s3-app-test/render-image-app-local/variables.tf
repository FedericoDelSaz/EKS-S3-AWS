variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where resources will be deployed"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)"
}

variable "app_name" {
  type        = string
  default     = "render-image-local"
  description = "The name of the application"
}
