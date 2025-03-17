variable "cluster_name" {
  description = "name of the cluster"
  type        = string
  default     = "dev-new-work"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}