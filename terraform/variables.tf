variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "aks_cluster_name" {
  description = "AKS Cluster Name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.33.7"
}

variable "node_vm_size" {
  description = "AKS Node VM Size"
  type        = string
  default     = "Standard_DC4as_v5"
}

variable "node_count" {
  description = "Initial Node Count"
  type        = number
  default     = 2
}

variable "min_node_count" {
  description = "Minimum Node Count for Autoscaler"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum Node Count for Autoscaler"
  type        = number
  default     = 3
}

variable "acr_name" {
  description = "Azure Container Registry Name"
  type        = string
}