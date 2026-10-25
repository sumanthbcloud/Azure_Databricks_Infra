# Azure Region
location = "southcentralus"

# Resource Names
resource_group_name = "lakehouse-rg"
vnet_name           = "lakehouse-vnet"
workspace_name      = "lakehouse-dbx"
cluster_name        = "lakehouse-cluster"

# Network CIDRs
vnet_address_space        = ["10.20.0.0/16"]
host_subnet_prefixes      = ["10.20.1.0/24"]
container_subnet_prefixes = ["10.20.2.0/24"]

# Databricks Compute Settings
cluster_node_type_id            = "Standard_D4ds_v5"
cluster_autotermination_minutes = 180

# ADLS Gen2 Storage (replace with your own unique name if needed)
adls_gen2_account_name    = "sumanthbmedallion"
adls_gen2_filesystem_name = "lakehouse"
