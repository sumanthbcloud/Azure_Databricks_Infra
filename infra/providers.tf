terraform {
  required_version = ">= 1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}

provider "azurerm" {
  features {}
  resource_providers_to_register = [
    "Microsoft.Compute",
    "Microsoft.Network",
    "Microsoft.Storage",
    "Microsoft.Databricks",
  ]
}

provider "databricks" {
  alias                       = "workspace"
  host                        = "https://${module.databricks_workspace.databricks_workspace_url}"
  azure_workspace_resource_id = module.databricks_workspace.databricks_workspace_id
}
