resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled                  = true
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

data "azurerm_client_config" "current" {}

locals {
  principal_id = coalesce(var.terraform_principal_object_id, data.azurerm_client_config.current.object_id)
}

resource "azurerm_role_assignment" "terraform_storage_data" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.principal_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.this.id

  depends_on = [
    azurerm_role_assignment.terraform_storage_data
  ]
}
