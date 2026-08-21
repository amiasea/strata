resource "azurerm_kubernetes_cluster" "atlas" {
  name                = "aks-strata-atlas"
  location            = var.location
  resource_group_name = var.azure_resource_group_name
  dns_prefix          = "strata-atlas"

  node_provisioning_profile {
    mode = "Manual"
  }

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
  }

  identity {
    type = "SystemAssigned"
  }
}
