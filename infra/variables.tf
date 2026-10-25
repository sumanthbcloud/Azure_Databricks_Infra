variable "location" {
  description = "Azure region where all infrastructure resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Additional tags applied to all Azure resources."
  type        = map(string)
  default     = {}
}

# Resource names
variable "resource_group_name" {
  description = "Name for the Azure Resource Group."
  type        = string
  default     = "lakehouse-rg"
}

variable "vnet_name" {
  description = "Name for the Azure Virtual Network."
  type        = string
  default     = "lakehouse-vnet"
}

variable "workspace_name" {
  description = "Name for the Azure Databricks workspace."
  type        = string
  default     = "lakehouse-dbx"
}

variable "cluster_name" {
  description = "Name for the Databricks compute cluster."
  type        = string
  default     = "lakehouse-cluster"
}

# ADLS Gen2 storage
variable "adls_gen2_account_name" {
  description = "Globally unique name for the ADLS Gen2 storage account."
  type        = string
  default     = "sumanthbmedallion"
}

variable "adls_gen2_filesystem_name" {
  description = "Name of the ADLS Gen2 filesystem/container."
  type        = string
  default     = "lakehouse"
}

# Databricks compute settings
variable "cluster_node_type_id" {
  description = "Azure VM node type for the single-node compute cluster."
  type        = string
  default     = "Standard_D4ds_v4"
}

variable "cluster_autotermination_minutes" {
  description = "Automatically terminate cluster after this number of minutes of inactivity."
  type        = number
  default     = 180
}

variable "cluster_spark_version" {
  description = "Optional custom Spark runtime version. If null, the latest LTS version is auto-detected."
  type        = string
  default     = null
}

variable "databricks_sku" {
  description = "SKU for the Azure Databricks workspace (standard, premium, or enterprise)."
  type        = string
  default     = "premium"
}

# Networking CIDRs
variable "vnet_address_space" {
  description = "CIDR block address space for the virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "host_subnet_prefixes" {
  description = "CIDR prefix for the Databricks host (public) subnet."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "container_subnet_prefixes" {
  description = "CIDR prefix for the Databricks container (private) subnet."
  type        = list(string)
  default     = ["10.20.2.0/24"]
}
