variable "cluster_name" {
  description = "name of the cluster"
  type        = string
  default     = "dev-new-work"
}

variable "namespace" {
  default = "s3-app-nw"
}

variable "issue_name" {
  default = "letsencrypt-dev"
}

variable "domain_name" {
  default = "new-work-se-test.com"
}