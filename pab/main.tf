
resource "google_iam_principal_access_boundary_policy" "parameterized_pab" {
  organization                        = var.organization_id
  location                            = var.location
  principal_access_boundary_policy_id = var.pab_policy_id
  display_name                        = var.display_name

  details {
    enforcement_version = "latest"

    dynamic "rules" {
      for_each = var.rules
      content {
        description = rules.value.description
        effect      = rules.value.effect
        resources   = rules.value.resources
      }
    }
  }
}

resource "google_iam_projects_policy_binding" "parameterized_pab_binding" {
  project  = var.project_id
  location = var.location

  principal_access_boundary_policy = google_iam_principal_access_boundary_policy.parameterized_pab.id
  target_principal_set             = var.target_principal_set
  display_name                     = var.binding_display_name

  dynamic "condition" {
    for_each = var.binding_condition_expression == "" ? [] : [1]
    content {
      title       = var.binding_condition_title
      description = var.binding_condition_description
      expression  = var.binding_condition_expression
    }
  }
}
