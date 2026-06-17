# These controls are now enabled as the resource types aiplatform.googleapis.com/ReasoningEngine
# and networkservices.googleapis.com/AgentGateway are supported by the Compliance Manager service.
resource "google_cloud_security_compliance_cloud_control" "require_agent_identity_custom" {
  provider         = google-beta
  organization     = var.organization_id
  location         = var.location
  cloud_control_id = "require-agent-identity-custom"

  display_name      = "Require Agent Identity for ReasoningEngine"
  description       = "Ensures all Vertex AI ReasoningEngine instances use Agent Identity."
  categories        = ["CC_CATEGORY_INFRASTRUCTURE"]
  severity          = "HIGH"
  finding_category  = "SECURITY"
  remediation_steps = "Update the ReasoningEngine to use AGENT_IDENTITY."

  supported_cloud_providers = ["GCP"]

  rules {
    description       = "ReasoningEngine should use AGENT_IDENTITY."
    rule_action_types = ["RULE_ACTION_TYPE_DETECTIVE"]

    cel_expression {
      expression = "resource.data.spec.identityType == 'AGENT_IDENTITY'"
      resource_types_values {
        values = ["aiplatform.googleapis.com/ReasoningEngine"]
      }
    }
  }
}

resource "google_cloud_security_compliance_cloud_control" "require_agent_gateway_custom" {
  provider         = google-beta
  organization     = var.organization_id
  location         = var.location
  cloud_control_id = "require-agent-gateway-custom"

  display_name      = "Require Agent Gateway for Agent Engine"
  description       = "Ensures all Vertex AI ReasoningEngine instances have at least one Agent Gateway configured."
  categories        = ["CC_CATEGORY_INFRASTRUCTURE"]
  severity          = "HIGH"
  finding_category  = "SECURITY"
  remediation_steps = "Configure an Agent Gateway for the ReasoningEngine."

  supported_cloud_providers = ["GCP"]

  rules {
    description       = "ReasoningEngine should have at least one Agent Gateway configured."
    rule_action_types = ["RULE_ACTION_TYPE_DETECTIVE"]

    cel_expression {
      expression = <<EOT
has(resource.data.spec) &&
has(resource.data.spec.deploymentSpec) &&
has(resource.data.spec.deploymentSpec.agentGatewayConfig) &&
(
  (has(resource.data.spec.deploymentSpec.agentGatewayConfig.clientToAgentConfig) &&
   has(resource.data.spec.deploymentSpec.agentGatewayConfig.clientToAgentConfig.agentGateway) &&
   resource.data.spec.deploymentSpec.agentGatewayConfig.clientToAgentConfig.agentGateway != '')
  ||
  (has(resource.data.spec.deploymentSpec.agentGatewayConfig.agentToAnywhereConfig) &&
   has(resource.data.spec.deploymentSpec.agentGatewayConfig.agentToAnywhereConfig.agentGateway) &&
   resource.data.spec.deploymentSpec.agentGatewayConfig.agentToAnywhereConfig.agentGateway != '')
)
EOT
      resource_types_values {
        values = ["aiplatform.googleapis.com/ReasoningEngine"]
      }
    }
  }
}

# This control is commented out because the resource type networkservices.googleapis.com/AgentGateway
# is not currently supported by the Compliance Manager service (likely not in CAI).
# Fix needed: Support for this resource type in CAI and Compliance Manager.
# resource "google_cloud_security_compliance_cloud_control" "agent_gateway_secure_config" {
#   provider         = google-beta
#   organization     = var.organization_id
#   location         = var.location
#   cloud_control_id = "agent-gateway-secure-config"
# 
#   display_name      = "Agent Gateway Secure Configuration"
#   description       = "Ensures all Agent Gateways have both Model Armor and IAP enabled."
#   categories        = ["CC_CATEGORY_INFRASTRUCTURE"]
#   severity          = "HIGH"
#   finding_category  = "SECURITY"
#   remediation_steps = "Enable Model Armor and IAP on the Agent Gateway."
# 
#   supported_cloud_providers = ["GCP"]
# 
#   rules {
#     description       = "Agent Gateway should have Model Armor and IAP enabled."
#     rule_action_types = ["RULE_ACTION_TYPE_DETECTIVE"]
# 
#     cel_expression {
#       expression = "has(resource.data.iapEnabled) && resource.data.iapEnabled == true && has(resource.data.modelArmorEnabled) && resource.data.modelArmorEnabled == true"
#       resource_types_values {
#         values = ["networkservices.googleapis.com/AgentGateway"]
#       }
#     }
#   }
# }
