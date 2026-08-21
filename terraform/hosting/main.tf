output "cluster" {
  description = "The Atlas Hosting cluster."

  value = {
    name                = azurerm_kubernetes_cluster.atlas.name
    id                  = azurerm_kubernetes_cluster.atlas.id
    resource_group_name = azurerm_resource_group.hosting_1.name
    location            = azurerm_kubernetes_cluster.atlas.location
  }
}