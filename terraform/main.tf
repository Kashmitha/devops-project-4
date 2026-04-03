# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = "devops-project-4"
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedDate = "2026-04"
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    Project     = "devops-project-4"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Log Analytics Workspace for AKS Monitoring
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.aks_cluster_name}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Project   = "devops-project-4"
    ManagedBy = "Terraform"
  }
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.aks_cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version

  # System Node Pool
  default_node_pool {
    name       = "system"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    #os_sku                      = "AzureLinux"
    auto_scaling_enabled        = true
    min_count                   = var.min_node_count
    max_count                   = var.max_node_count
    os_disk_size_gb             = 64
    temporary_name_for_rotation = "systemtmp"

    upgrade_settings {
      max_surge                     = "1"
      drain_timeout_in_minutes      = 30
      node_soak_duration_in_minutes = 0
    }

    node_labels = {
      "role"        = "system"
      "environment" = var.environment
    }
  }

  # Manage Identity for Cluster
  identity {
    type = "SystemAssigned"
  }

  # Network Configuration
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  # RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = "06bdb2d5-4149-4b49-a469-22d89b2f9dd4"
  }
  # Container Insights
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  # Automatic Upgrades
  automatic_upgrade_channel = "patch"

  tags = {
    Project     = "devops-project-4"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ACR -> AKS Pull Permission
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}