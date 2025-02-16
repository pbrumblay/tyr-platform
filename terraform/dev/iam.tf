locals {
    java_service_roles = toset([
      "roles/storageObject.viewer"
    ])
}

resource "google_service_account" "java_service_sa" {
  provider     = google-beta
  account_id   = "java-service-sa"
  display_name = "Cloud Deploy Service Account"
  project      = var.platform_project_id
}

resource "google_project_iam_member" "java_service_sa_platform_roles" {
  provider     = google-beta
  for_each = local.java_service_roles
  project = var.dev_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.java_service_sa.email}"
}
