variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for the storage resources."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique name for the ADLS Gen2 storage account (3-24 lowercase alphanumeric characters)."
  type        = string
}

variable "container_name" {
  description = "Name of the private data container / filesystem for Databricks data."
  type        = string
  default     = "lakehouse"
}

variable "terraform_principal_object_id" {
  description = "Optional Object ID of the identity (User or Service Principal) requiring data-plane access. If omitted, the currently authenticated Azure identity is automatically detected."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to all storage resources."
  type        = map(string)
  default     = {}
}
