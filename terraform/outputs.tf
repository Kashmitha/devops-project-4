output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "kubernetes_version" {
  value = azurerm_kubernetes_cluster.main.kubernetes_version
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = azurerm_container_registry.main.login_server
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "node_pool_vm_size" {
  value = azurerm_kubernetes_cluster.main.default_node_pool[0].vm_size
}

output "get_credentials_command" {
  description = "Run this to connect kubectl to your cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name} --overwrite-existing"
}