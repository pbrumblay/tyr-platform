resource "google_clouddeploy_delivery_pipeline" "pipeline" {
  provider = google-beta
  location = var.region
  name     = "tyr-java-service-pipeline"
  project  = var.platform_project_id

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.dev.name
      profiles  = ["dev"]
      deploy_parameters {
        values = {
          project_id = var.dev_project_id
        }
      }      
    }

    stages {
      target_id = google_clouddeploy_target.stage.name
      profiles  = ["stage"]
      deploy_parameters {
        values = {
          project_id = var.stage_project_id
        }
      }      
    }    
    
    stages {
      target_id = google_clouddeploy_target.prod.name
      profiles  = ["prod"]
      deploy_parameters {
        values = {
          project_id = var.prod_project_id
        }
      }      
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
        "roles/storage.objectAdmin"
    ])
    project_impersonation_grants = toset(
      [
        var.dev_project_id,
        var.stage_project_id,
        var.prod_project_id
      ]
    )
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

# Grant Cloud Deploy SA the ability to impersonate Cloud Run service accounts
resource "google_service_account_iam_member" "clouddeploy_actas_cloudrun" {
  provider = google-beta
  for_each = local.project_impersonation_grants
  service_account_id = "projects/${each.key}/serviceAccounts/tyr-java-service-sa@${each.key}.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.clouddeploy_sa.email}"
}
