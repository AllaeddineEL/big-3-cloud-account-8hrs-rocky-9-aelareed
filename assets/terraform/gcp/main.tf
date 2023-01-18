provider "google" {
  version = "4.7.0"
  region  = var.region
  project = var.gcp_project_id
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }

  required_version = ">= 0.14"
}
