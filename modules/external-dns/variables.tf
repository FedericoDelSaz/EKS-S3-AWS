variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster Id"
}

variable "eks_oidc_issuer_url" {
  type        = string
  description = "The URL on the EKS cluster OIDC Issuer"
}

variable "aws_account_id" {
  description = "account id number"
  type        = string
}

variable "aws_network_account_id" {
  type        = string
  description = "account id number of the network account"
  default     = "640847272048"
}

variable "external_dns_chart_log_level" {
  description = "External-dns Helm chart log leve. Possible values are: panic, debug, info, warn, error, fatal"
  type        = string
  default     = "debug"
}

variable "external_dns_source_discovery" {
  description = "Configures the sources external dns will scan for possible hosts"
  type        = string
  default     = "{ingress,service}"
}
