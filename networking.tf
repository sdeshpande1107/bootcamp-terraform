# Creating virtual network and subnets : 

resource "azurerm_virtual_network" "vmss" {
  name                = var.azurerm_virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.vmss
  ]
}

resource "azurerm_subnet" "vmss-public-subnet" {
  name                 = "vmss-public-subnet"
  resource_group_name  = azurerm_resource_group.vmss.name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [
    azurerm_virtual_network.vmss
  ]
}

resource "azurerm_subnet" "vmss-private-subnet" {
  name                 = "vmss-private-subnet"
  resource_group_name  = azurerm_resource_group.vmss.name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes     = ["10.0.3.0/24"]
  depends_on = [
    azurerm_virtual_network.vmss
  ]
}