variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where resources will be deployed"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}
