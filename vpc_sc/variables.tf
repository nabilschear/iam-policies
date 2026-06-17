variable "access_policy_id" {
  type        = string
  description = "The ID of the Access Policy that this perimeter belongs to."
}

variable "project_number" {
  type        = string
  description = "The project number of the project to enclose in the perimeter."
}

variable "perimeter_name_suffix" {
  type        = string
  description = "Suffix to append to the perimeter name to make it unique."
}

variable "restricted_services" {
  type        = list(string)
  description = "The list of services to restrict in the perimeter."
  default     = [
    "aiplatform.googleapis.com",
    "storage.googleapis.com",
    "bigquery.googleapis.com"
  ]
}

variable "access_level_ips" {
  type        = list(string)
  description = "List of IP ranges allowed to access the resources inside the perimeter."
  default     = []
}
