locals {
  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}

module "resource_group" {
  source = "../modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "vnet" {
  source = "../modules/vnet"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location

  vnet_name     = var.vnet_name
  address_space = var.vnet_address_space

  host_subnet = {
    name             = "snet-dbx-host"
    address_prefixes = var.host_subnet_prefixes
    nsg_name         = "nsg-dbx-host"
  }

  container_subnet = {
    name             = "snet-dbx-container"
    address_prefixes = var.container_subnet_prefixes
    nsg_name         = "nsg-dbx-container"
  }

  nat_gateway = {
    name           = "${var.vnet_name}-nat"
    public_ip_name = "${var.vnet_name}-nat-pip"
  }

  tags = local.tags
}

module "databricks_workspace" {
  source = "../modules/databricks-workspace"

  workspace_name              = var.workspace_name
  managed_resource_group_name = "${var.workspace_name}-managed-rg"
  sku                         = var.databricks_sku

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location

  vnet_id                      = module.vnet.vnet_id
  host_subnet_name             = module.vnet.host_subnet_name
  container_subnet_name        = module.vnet.container_subnet_name
  host_nsg_association_id      = module.vnet.host_nsg_association_id
  container_nsg_association_id = module.vnet.container_nsg_association_id

  tags = local.tags
}

module "adls_gen2" {
  source = "../modules/adls-gen2"

  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.location
  storage_account_name = var.adls_gen2_account_name
  container_name       = var.adls_gen2_filesystem_name

  tags = local.tags
}

# Wait 3 minutes for Databricks workspace plane initialization
resource "time_sleep" "wait_for_databricks" {
  depends_on = [module.databricks_workspace]

  create_duration = "180s"
}

module "databricks_cluster" {
  source = "../modules/databricks-cluster"

  providers = {
    databricks = databricks.workspace
  }

  cluster_name            = var.cluster_name
  spark_version           = var.cluster_spark_version
  node_type_id            = var.cluster_node_type_id
  autotermination_minutes = var.cluster_autotermination_minutes

  tags = local.tags

  depends_on = [
    time_sleep.wait_for_databricks
  ]
}
