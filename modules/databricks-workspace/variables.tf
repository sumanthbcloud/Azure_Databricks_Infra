variable "workspace_name" {
  description = "Name of the Azure Databricks workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the workspace."
  type        = string
}

variable "location" {
  description = "Azure region for the Databricks workspace."
  type        = string
}

variable "managed_resource_group_name" {
  description = "Name of the resource group managed by Databricks for workspace cluster resources."
  type        = string
}

variable "sku" {
  description = "The SKU to use for the Databricks workspace (standard, premium, or enterprise)."
  type        = string
  default     = "premium"
}

variable "vnet_id" {
  description = "The ID of the Virtual Network where Databricks will be injected."
  type        = string
}

variable "host_subnet_name" {
  description = "The name of the Databricks host (public) subnet."
  type        = string
}

variable "container_subnet_name" {
  description = "The name of the Databricks container (private) subnet."
  type        = string
}

variable "host_nsg_association_id" {
  description = "The ID of the subnet NSG association for the host subnet."
  type        = string
}

variable "container_nsg_association_id" {
  description = "The ID of the subnet NSG association for the container subnet."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Databricks workspace."
  type        = map(string)
  default     = {}
}
