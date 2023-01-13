output "gcp_gke_cluster_shared_name" {
  value = google_container_cluster.consul.name
}

output "gcp_shared_svcs_network_self_link" {
  value = module.gcp-vpc-consul.network_self_link
}

output "gcp_consul_service_account_email" {
  value = google_service_account.consul.email
}
