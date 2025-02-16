resource "google_cloud_run_service" "java_service" {
  project  = var.dev_project_id
  name     = "java-service"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.java_service_sa.email
      containers {
        image = "gcr.io/cloudrun/placeholder" # This will be replaced by Cloud Deploy
      }
    }
  }
}