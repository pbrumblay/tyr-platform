# Repository v2 link
resource "google_cloudbuildv2_repository" "tyr_java_service_repo" {
  project           = var.platform_project_id
  location          = var.region
  name              = "tyr-java-service-repo"
  parent_connection = google_cloudbuildv2_connection.github_connection.name
  remote_uri        = "https://github.com/pbrumblay/tyr-java-service.git"
}

resource "google_service_account" "cloudbuild_service_account" {
  account_id   = "cloudbuild-service-account"
  display_name = "Cloud Build Service Account"
  description  = "Service account for Cloud Build"
}

resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/deploymentmanager.editor",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
    "roles/clouddeploy.operator"
  ])

  project = var.platform_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

# Grant Cloud Build SA the ability to impersonate Cloud Deploy SA
resource "google_service_account_iam_member" "cloudbuild_actas_clouddeploy" {
  provider = google-beta
  service_account_id = google_service_account.clouddeploy_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

# Grant builder access to gradle cache bucket.
resource "google_storage_bucket_iam_binding" "gradle_cache_user" {
  bucket = google_storage_bucket.gradle_cache.name
  role   = "roles/storage.objectAdmin"  # Provides full access to objects in the bucket
  members = [
    "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
  ]
}

# Create Cloud Build trigger for deployment updates
resource "google_cloudbuild_trigger" "tyr_java_service" {
  name        = "tyr-java-service"
  description = "Trigger for java service"
  project     = var.platform_project_id
  location = var.region
  service_account = google_service_account.cloudbuild_service_account.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.tyr_java_service_repo.id
    push {
      branch = "^main$"
    }
  }

  filename = ".ci/cloudbuild.yaml"
}