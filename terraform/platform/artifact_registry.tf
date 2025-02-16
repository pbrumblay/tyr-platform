resource "google_artifact_registry_repository" "applications" {
  provider = google-beta
  location      = var.region
  repository_id = "applications"
  description   = "Repository for application artifacts"
  format        = "DOCKER"

  # Cleanup policies configuration
  cleanup_policies {
    id     = "retain-promoted-releases"
    action = "KEEP"
    condition {
      tag_state  = "TAGGED"
      tag_prefixes = ["prod-ready-"]
    }
  }

  cleanup_policies {
    id     = "clean-old-untagged"
    action = "DELETE"
    condition {
      tag_state = "UNTAGGED"
      older_than = "2592000s"    # Delete untagged images older than 30 days
    }
  }
}