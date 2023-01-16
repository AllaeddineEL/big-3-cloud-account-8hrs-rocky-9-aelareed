resource "azurerm_resource_group" "rg" {
  name     = "consul-multicloud"
  location = "westeurope"
}


module "network" {
  source              = "Azure/network/azurerm"
  version             = "3.5.0"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = "consul"
  address_space       = "10.1.0.0/16"
  subnet_prefixes     = ["10.1.1.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.rg]
}


module "aks" {
  source                            = "Azure/aks/azurerm"
  version                           = "6.5.0"
  resource_group_name               = azurerm_resource_group.rg.name
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  kubernetes_version                = "1.25.4"
  orchestrator_version              = "1.25.4"
  prefix                            = "consul-multicloud"
  cluster_name                      = "consul-aks"
  network_plugin                    = "azure"
  vnet_subnet_id                    = module.network.vnet_subnets[0]
  role_based_access_control_enabled = true
  rbac_aad_managed                  = true
  private_cluster_enabled           = false
  log_analytics_workspace_enabled   = false
  agents_count                      = 2
  agents_availability_zones         = ["1", "2"]

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  network_policy = "azure"
  depends_on     = [module.network]
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
