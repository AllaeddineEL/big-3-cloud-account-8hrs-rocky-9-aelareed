module "gcp-vpc-consul" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.gcp_project_id
  network_name = "consul"
  subnets = [
    {
      subnet_name           = "shared"
      subnet_ip             = "10.1.0.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
    },
  ]
}

resource "google_container_cluster" "consul" {
  provider           = google-beta
  project            = var.gcp_project_id
  name               = "consul-gke"
  location           = "us-central1-a"
  initial_node_count = 2

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {}

  network    = module.gcp-vpc-consul.network_name
  subnetwork = "shared"

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # IL-495
  min_master_version = "1.21.14-gke.8500"
  node_version       = "1.21.14-gke.8500"
  # GKE mandates at least 48hr of maintenance window in a 32 day period.
  # We don't want upgrades during a lab, so we use the below values.
  # Choose two six-hour windows on Saturday and Sunday.
  # The earliest maintenance would start would be on a Saturday at 3am
  # in Honolulu, the latest would be Monday 4am in Tokyo, to pick locales
  # roughly at either end of time zone offsets
  maintenance_policy {
    recurring_window {
      start_time = "2022-12-11T13:00:00Z"
      end_time   = "2022-12-11T19:00:00Z"
      recurrence = "FREQ=WEEKLY;WKST=SU;BYDAY=SA,SU"
    }
  }
  # IL-495

  node_config {
    service_account = data.terraform_remote_state.iam.outputs.gcp_consul_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    machine_type = "n1-standard-2"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    tags = ["consul-server", "consul-connect"]
  }

  enable_legacy_abac = true

  timeouts {
    create = "30m"
    update = "40m"
  }
}
