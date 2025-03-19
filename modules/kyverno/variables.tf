variable "kyverno_enabled" {
  description = "Defines if Kyverno is enabled for this cluster."
  default     = "false"
}

variable "kyverno_common_policies_enabled" {
  description = "Defines if Kyverno common policies are enabled for this cluster."
  default     = "true"
}

variable "kyverno_common_policies_chart_name" {
  type    = string
  default = "kyverno-common-policies"
}

variable "kyverno_policies_chart_namespace" {
  type    = string
  default = "new-work-policies"
}

variable "kyverno_policies_values_file" {
  type    = string
  default = "kyverno-policies/values.yaml"
}

variable "kyverno_chart_version" {
  type = object({
    chart_version = string
    values_file   = string
  })
  default = {
    chart_version = "v3.1.5" # variable of official Kyverno chart. It is linked with Kyverno version (kyverno-<VERSION>.values.yaml)
    values_file   = "kyverno-1115-values.yaml"
  }
}
