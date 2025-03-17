variable "account_alias" {
  description = "The name of the key alias"
  type        = string
}

variable "deletion_window_in_days" {
  description = "The duration in days after which the key is deleted after destruction of the resource"
  type        = string
  default     = "7"
}

variable "customer_master_key_spec" {
  description = "Specifies the encryption algorithm"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of this KMS key"
  type        = string
  default     = "XSP created KMS Key for encryption"
}
