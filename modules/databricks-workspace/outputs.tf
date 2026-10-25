output "databricks_workspace_name" {
  description = "The name of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.workspace.name
}

output "databricks_workspace_id" {
  description = "The ID of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.workspace.id
}

output "databricks_workspace_url" {
  description = "The workspace URL associated with the Databricks workspace."
  value       = azurerm_databricks_workspace.workspace.workspace_url
}
