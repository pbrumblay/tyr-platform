resource "google_project_service" "project_services" {
  for_each                   = toset(var.services)
  project                    = var.stage_project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

data "google_project" "stage_project" {
  project_id = var.stage_project_id
}

terraform {
  backend "gcs" {}
}