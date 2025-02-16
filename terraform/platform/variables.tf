variable "services" {
  description = "Service APIs to enable."
  type        = list(string)
  default     = [
    "clouddeploy.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

variable "platform_project_id" {
  type = string
}

variable "dev_project_id" {
  type = string
}

variable "stage_project_id" {
  type = string
}

variable "prod_project_id" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "github_pat" {
  type = string
  sensitive = true
}

variable "github_cloudbuild_app_installation_id" {
  type = string
  sensitive = true
}