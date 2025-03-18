variable "namespace" {
}

variable "bucket_name" {}

variable "environment" {
  type = string
}

variable "app_name" {
  default = "render-image-local"
}