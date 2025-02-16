resource "google_cloud_run_v2_service" "java_service" {
  project  = var.prod_project_id
  name     = "tyr-java-service"
  location = var.region
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER" 

  template {
    service_account =  google_service_account.tyr_java_service_sa.email
      containers {
        image = "gcr.io/cloudrun/placeholder" # This will be replaced by Cloud Deploy
        resources {
          limits = {
            cpu    = "2000m"
            memory = "2048Mi"
          }
          cpu_idle = true
        }        
      }
  }
}