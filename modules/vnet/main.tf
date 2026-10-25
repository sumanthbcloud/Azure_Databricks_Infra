resource "terraform_data" "network_watcher_cleanup" {
  input = "NetworkWatcherRG"

  provisioner "local-exec" {
    when    = destroy
    command = "az group delete --name ${self.output} --yes --no-wait || exit 0"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags

  depends_on = [
    terraform_data.network_watcher_cleanup
  ]
}

resource "azurerm_subnet" "host" {
  name                 = var.host_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.host_subnet.address_prefixes

  delegation {
    name = "databricks-delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet" "container" {
  name                 = var.container_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.container_subnet.address_prefixes

  delegation {
    name = "databricks-delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "host" {
  name                = var.host_subnet.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "container" {
  name                = var.container_subnet.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "host" {
  subnet_id                 = azurerm_subnet.host.id
  network_security_group_id = azurerm_network_security_group.host.id
}

resource "azurerm_subnet_network_security_group_association" "container" {
  subnet_id                 = azurerm_subnet.container.id
  network_security_group_id = azurerm_network_security_group.container.id
}

resource "azurerm_public_ip" "nat" {
  name                = var.nat_gateway.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "nat" {
  name                = var.nat_gateway.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "host" {
  subnet_id      = azurerm_subnet.host.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "container" {
  subnet_id      = azurerm_subnet.container.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
