resource "terraform_data" "managed_rg_cleanup" {
  input = var.managed_resource_group_name

  provisioner "local-exec" {
    when    = destroy
    command = "az group delete --name ${self.output} --yes --no-wait || exit 0"
  }
}

resource "azurerm_databricks_workspace" "workspace" {
  name                        = var.workspace_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  managed_resource_group_name = var.managed_resource_group_name
  sku                         = var.sku
  tags                        = var.tags

  custom_parameters {
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.host_subnet_name
    private_subnet_name                                  = var.container_subnet_name
    public_subnet_network_security_group_association_id  = var.host_nsg_association_id
    private_subnet_network_security_group_association_id = var.container_nsg_association_id
    no_public_ip                                         = true
  }

  depends_on = [
    terraform_data.managed_rg_cleanup
  ]
}
