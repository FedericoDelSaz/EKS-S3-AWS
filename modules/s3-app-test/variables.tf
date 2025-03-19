variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where resources will be deployed"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "app_s3_enabled" {
  type        = bool
  default     = true
  description = "Flag to enable or disable S3 integration for the application"
}
