variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for the network resources."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "host_subnet" {
  description = "Configuration for the Databricks host subnet."
  type = object({
    name             = string
    address_prefixes = list(string)
    nsg_name         = string
  })
}

variable "container_subnet" {
  description = "Configuration for the Databricks container subnet."
  type = object({
    name             = string
    address_prefixes = list(string)
    nsg_name         = string
  })
}

variable "nat_gateway" {
  description = "Configuration for the NAT Gateway and Public IP."
  type = object({
    name           = string
    public_ip_name = string
  })
}

variable "tags" {
  description = "Tags to apply to network resources."
  type        = map(string)
  default     = {}
}
