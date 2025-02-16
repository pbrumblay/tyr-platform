resource "google_clouddeploy_delivery_pipeline" "pipeline" {
  provider = google-beta
  location = var.region
  name     = "tyr-java-service-pipeline"
  project  = var.platform_project_id

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.dev.name
      profiles  = ["dev"]
    }

    stages {
      target_id = google_clouddeploy_target.stage.name
      profiles  = ["stage"]
    }    
    
    stages {
      target_id = google_clouddeploy_target.prod.name
      profiles  = ["prod"]
    }
  }
}

locals {
    project_deploy_roles = toset([
     "roles/run.developer",
     "roles/clouddeploy.operator"
    ])
    platform_deploy_roles = toset([
        "roles/artifactregistry.reader",
        "roles/logging.logWriter",
        "roles/storage.objectViewer"
    ])
}

resource "google_service_account" "clouddeploy_sa" {
  provider     = google-beta
  account_id   = "clouddeploy-sa"
  display_name = "Cloud Deploy Service Account"
  project      = var.platform_project_id
}

resource "google_project_iam_member" "clouddeploy_sa_platform_roles" {
  provider     = google-beta
  for_each = local.platform_deploy_roles
  project = var.platform_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.clouddeploy_sa.email}"
}

resource "google_project_iam_member" "clouddeploy_sa_dev_roles" {
  provider     = google-beta
  for_each = local.project_deploy_roles
  project = var.dev_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.clouddeploy_sa.email}"
}

resource "google_project_iam_member" "clouddeploy_sa_stage_roles" {
  provider     = google-beta
  for_each = local.project_deploy_roles
  project = var.stage_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.clouddeploy_sa.email}"
}

resource "google_project_iam_member" "clouddeploy_sa_prod_roles" {
  provider     = google-beta
  for_each = local.project_deploy_roles
  project = var.prod_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.clouddeploy_sa.email}"
}