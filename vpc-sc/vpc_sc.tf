resource "google_access_context_manager_access_level" "access_level" {
  provider = google-beta
  count    = length(var.access_level_ips) > 0 ? 1 : 0
  parent   = "accessPolicies/${var.access_policy_id}"
  name     = "accessPolicies/${var.access_policy_id}/accessLevels/al_${var.perimeter_name_suffix}"
  title    = "al_${var.perimeter_name_suffix}"
  basic {
    conditions {
      ip_subnetworks = var.access_level_ips
    }
  }
}

resource "google_access_context_manager_service_perimeter" "service_perimeter" {
  provider    = google-beta
  parent      = "accessPolicies/${var.access_policy_id}"
  name        = "accessPolicies/${var.access_policy_id}/servicePerimeters/sp_${var.perimeter_name_suffix}"
  title       = "sp_${var.perimeter_name_suffix}"
  description = "VPC-SC Perimeter protecting project"
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    resources           = ["projects/${var.project_number}"]
    restricted_services = var.restricted_services
    access_levels       = length(var.access_level_ips) > 0 ? [google_access_context_manager_access_level.access_level[0].name] : []
  }
}
