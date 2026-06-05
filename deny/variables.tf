variable "project_id" {
  type        = string
  description = "The Project ID"
}

variable "location" {
  type        = string
  description = "The Location/Region"
  default     = "us-central1"
}

variable "exception_principals" {
  type        = list(string)
  description = "List of principals exempt from the deny rule"
  default     = []
}

variable "policy_id" {
  type        = string
  description = "The unique policy ID for the IAM Deny policy."
}

variable "display_name" {
  type        = string
  description = "A user-friendly display name for the policy."
}

variable "denied_permissions" {
  type        = list(string)
  description = "List of IAM permissions to deny."
}

