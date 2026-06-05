
resource "google_iam_deny_policy" "parameterized_deny" {
  provider     = google-beta
  name         = var.policy_id
  parent       = "cloudresourcemanager.googleapis.com/projects/${var.project_id}"
  display_name = var.display_name

  rules {
    description = "Managed preventive compliance IAM Deny policy"
    deny_rule {
      denied_principals = [
        "principalSet://goog/public:all"
      ]
      exception_principals = var.exception_principals
      denied_permissions   = var.denied_permissions

      dynamic "denial_condition" {
        for_each = var.denial_condition_expression != null ? [1] : []
        content {
          title      = var.denial_condition_title
          expression = var.denial_condition_expression
        }
      }
    }
  }
}
