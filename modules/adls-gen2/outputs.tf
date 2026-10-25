output "storage_account_name" {
  description = "ADLS Gen2 storage account name."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "ADLS Gen2 storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "filesystem_name" {
  description = "ADLS Gen2 filesystem name."
  value       = azurerm_storage_data_lake_gen2_filesystem.this.name
}
