variable "cluster_name" {
  description = "name of the cluster"
  type        = string
  default     = "dev"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_account_id" {
  type = string
  default = "676206941382"
}