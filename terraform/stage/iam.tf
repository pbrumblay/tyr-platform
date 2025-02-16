locals {
    tyr_java_service_roles = toset([
      "roles/logging.logWriter",
      "roles/storage.objectViewer"
    ])
}

resource "google_service_account" "tyr_java_service_sa" {
  provider     = google-beta
  account_id   = "tyr-java-service-sa"
  display_name = "Cloud Run Service Account"
  project      = var.stage_project_id
}

resource "google_project_iam_member" "tyr_java_service_sa_role_bindings" {
  provider     = google-beta
  for_each = local.tyr_java_service_roles
  project = var.stage_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.tyr_java_service_sa.email}"
}
