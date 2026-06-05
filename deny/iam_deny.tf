
resource "null_resource" "dummy" {
  triggers = {
    project_id = var.project_id
  }
}
