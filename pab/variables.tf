variable "project_id" {
  type        = string
  description = "The Project ID"
}

variable "organization_id" {
  type        = string
  description = "The Organization ID"
}

variable "location" {
  type        = string
  description = "The Location/Region"
  default     = "global"
}

variable "pab_policy_id" {
  type        = string
  description = "The unique ID of the Principal Access Boundary policy."
}

variable "display_name" {
  type        = string
  description = "A user-friendly display name for the PAB policy."
}

variable "rules" {
  type = list(object({
    description = string
    effect      = string
    resources   = list(string)
  }))
  description = "List of PAB rules containing description, effect, and resource lists."
}

variable "target_principal_set" {
  type        = string
  description = "The principal set that the PAB policy binding applies to."
}

variable "binding_display_name" {
  type        = string
  description = "A user-friendly display name for the policy binding."
}

variable "binding_condition_title" {
  type        = string
  description = "Optional title for binding condition."
  default     = null
}

variable "binding_condition_description" {
  type        = string
  description = "Optional description for binding condition."
  default     = null
}

variable "binding_condition_expression" {
  type        = string
  description = "Optional CEL expression for binding condition."
  default     = null
}
