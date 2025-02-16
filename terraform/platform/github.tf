// Create a secret containing the personal access token and grant permissions to the Service Agent
resource "google_secret_manager_secret" "github_token_secret" {
    project =  var.platform_project_id
    secret_id = "github-pat"

    replication {
        auto {}
    }
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
    secret = google_secret_manager_secret.github_token_secret.id
    secret_data = var.github_pat
}

resource "google_secret_manager_secret_iam_member" "builder_github_pat_access" {
  project = google_secret_manager_secret.github_token_secret.project
  secret_id = google_secret_manager_secret.github_token_secret.secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

// Create the GitHub connection
resource "google_cloudbuildv2_connection" "github_connection" {
    project = var.platform_project_id
    location = var.region
    name = "github-connection"

    github_config {
        app_installation_id = var.github_cloudbuild_app_installation_id
        authorizer_credential {
            oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
        }
    }
}