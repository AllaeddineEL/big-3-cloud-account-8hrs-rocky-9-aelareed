resource "azurerm_resource_group" "rg" {
  name     = "acme-demo-rg"
  location = "westeurope"
}


module "network" {
  source              = "app.terraform.io/aelareed-acme/network/azurerm"
  version             = "3.5.0"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = "10.52.0.0/16"
  subnet_prefixes     = ["10.52.0.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.rg]
}


module "aks" {
  source                           = "app.terraform.io/aelareed-acme/aks/azurerm"
  version                          = "4.17.0"
  resource_group_name              = azurerm_resource_group.rg.name
  client_id                        = var.client_id
  client_secret                    = var.client_secret
  kubernetes_version               = "1.23.5"
  orchestrator_version             = "1.23.5"
  prefix                           = "demo"
  cluster_name                     = "acme"
  network_plugin                   = "azure"
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  enable_role_based_access_control = true
  rbac_aad_managed                 = true
  private_cluster_enabled          = false
  enable_log_analytics_workspace   = false
  agents_count                     = 2
  agents_availability_zones        = ["1", "2"]

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  network_policy = "azure"
  depends_on     = [module.network]
}