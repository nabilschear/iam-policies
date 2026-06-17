resource "google_cloud_security_compliance_framework" "secure_ai_app_framework" {
  provider     = google-beta
  organization = var.organization_id
  location     = var.location
  framework_id = "secure-ai-app-framework"

  display_name = "Secure AI App Framework"
  description  = "Custom framework for Secure AI Application standards."

  # These control references are now enabled as the referenced controls are supported.
  cloud_control_details {
    name              = google_cloud_security_compliance_cloud_control.require_agent_identity_custom.name
    major_revision_id = "1"
  }

  cloud_control_details {
    name              = google_cloud_security_compliance_cloud_control.require_agent_gateway_custom.name
    major_revision_id = "1"
  }

  # This control reference is commented out because the referenced control is also commented out (unsupported resource type).
  # cloud_control_details {
  #   name              = google_cloud_security_compliance_cloud_control.agent_gateway_secure_config.name
  #   major_revision_id = "1"
  # }
}
