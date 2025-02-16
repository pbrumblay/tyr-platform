# Create the storage bucket for Gradle cache
resource "google_storage_bucket" "gradle_cache" {
  name          = "${var.platform_project_id}-gradle-cache"
  location      = var.region
  force_destroy = true  # Allows terraform destroy to remove the bucket even if it contains objects

  # Optional but recommended settings
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced" 

  versioning {
    enabled = false  # No need to version cache files
  }
  
  # Lifecycle rule to clean up old cache files (optional)
  lifecycle_rule {
    condition {
      age = 30  # Days
    }
    action {
      type = "Delete"
    }
  }
}