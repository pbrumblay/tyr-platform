variable "services" {
  description = "Service APIs to enable."
  type        = list(string)
  default     = [
    "clouddeploy.googleapis.com",
    "run.googleapis.com"
  ]
}

variable "platform_project_id" {
  type = string
}

variable "dev_project_id" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}