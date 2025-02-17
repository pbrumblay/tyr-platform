resource "google_clouddeploy_target" "dev" {
  provider = google-beta
  location = var.region
  name     = "java-service-dev"
  project  = var.platform_project_id
  require_approval = false

  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    service_account   = google_service_account.clouddeploy_sa.email
  }

  run {
    location = "projects/${var.dev_project_id}/locations/${var.region}"
  }
}

resource "google_clouddeploy_target" "stage" {
  provider = google-beta
  location = var.region
  name     = "java-service-stage"
  project  = var.platform_project_id
  require_approval = true

  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    service_account   = google_service_account.clouddeploy_sa.email
  }

  run {
    location = "projects/${var.stage_project_id}/locations/${var.region}"
  }
}

resource "google_clouddeploy_target" "prod" {
  provider     = google-beta
  location = var.region
  name     = "java-service-prod"
  project  = var.platform_project_id
  require_approval = true

  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    service_account   = google_service_account.clouddeploy_sa.email
  }

  run {
    location = "projects/${var.prod_project_id}/locations/${var.region}"
  }
}