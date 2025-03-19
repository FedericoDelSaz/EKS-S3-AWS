variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where resources will be deployed"
}

variable "issuer_name" {
  type        = string
  description = "The name of the issuer for certificate management"
}
