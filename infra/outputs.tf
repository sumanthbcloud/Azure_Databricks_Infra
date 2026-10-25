output "resource_group_name" {
  description = "Resource Group name."
  value       = module.resource_group.resource_group_name
}

output "vnet_name" {
  description = "Virtual Network name."
  value       = module.vnet.vnet_name
}

output "vnet_id" {
  description = "Virtual Network resource ID."
  value       = module.vnet.vnet_id
}

output "databricks_workspace_name" {
  description = "Databricks workspace name."
  value       = module.databricks_workspace.databricks_workspace_name
}

output "databricks_workspace_url" {
  description = "Databricks workspace URL."
  value       = "https://${module.databricks_workspace.databricks_workspace_url}"
}

output "databricks_cluster_id" {
  description = "Databricks compute cluster ID."
  value       = module.databricks_cluster.cluster_id
}

output "databricks_cluster_url" {
  description = "Databricks cluster configuration URL."
  value       = module.databricks_cluster.cluster_url
}

output "adls_gen2_account_name" {
  description = "ADLS Gen2 storage account name."
  value       = module.adls_gen2.storage_account_name
}

output "adls_gen2_filesystem_name" {
  description = "ADLS Gen2 filesystem name."
  value       = module.adls_gen2.filesystem_name
}
