variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy NGINX Ingress Controller"
  type        = string
  default     = "kube-system"
}

variable "nginx_ingress_version" {
  description = "NGINX Ingress Controller version"
  type        = string
  default     = "4.12.0"
}

variable "additional_values_file_path_nginx_custom" {
  type    = string
  default = "nginx/custom-nginx-values.yaml"
}