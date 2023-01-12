output "client_key" {
  sensitive = true
  value     = base64decode(module.aks.client_key)
}

output "client_certificate" {
  sensitive = true
  value     = base64decode(module.aks.client_certificate)
}

output "cluster_ca_certificate" {
  sensitive = true
  value     = base64decode(module.aks.cluster_ca_certificate)
}

output "host" {
  sensitive = true
  value     = module.aks.host
}

output "username" {
  sensitive = true
  value     = module.aks.username
}

output "password" {
  sensitive = true
  value     = module.aks.password
}
