output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "host_subnet_id" {
  description = "ID of the Databricks host subnet."
  value       = azurerm_subnet.host.id
}

output "container_subnet_id" {
  description = "ID of the Databricks container subnet."
  value       = azurerm_subnet.container.id
}

output "host_subnet_name" {
  description = "Name of the Databricks host subnet."
  value       = azurerm_subnet.host.name
}

output "container_subnet_name" {
  description = "Name of the Databricks container subnet."
  value       = azurerm_subnet.container.name
}

output "host_nsg_association_id" {
  description = "Association ID for the host subnet and its NSG."
  value       = azurerm_subnet_network_security_group_association.host.id
}

output "container_nsg_association_id" {
  description = "Association ID for the container subnet and its NSG."
  value       = azurerm_subnet_network_security_group_association.container.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway."
  value       = azurerm_nat_gateway.nat.id
}
