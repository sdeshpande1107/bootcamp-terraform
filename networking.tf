# Creating virtual network and subnets : 

resource "azurerm_virtual_network" "vmss" {
  name                = var.azurerm_virtual_network
  address_space       = ["192.168.0.0/24"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.vmss
  ]
}

resource "azurerm_subnet" "vmss-public-subnet" {
  name                 = "vmss-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes     = ["192.168.0.0/25"]
  depends_on = [
    azurerm_virtual_network.vmss
  ]
}

resource "azurerm_subnet" "vmss-private-subnet" {
  name                 = "vmss-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes     = ["192.168.0.128/26"]
  depends_on = [
    azurerm_virtual_network.vmss
  ]
}


#create postgres subnet:

resource "azurerm_subnet" "vmss-postgres-subnet" {
  name                 = "postgres-subnet"
  address_prefixes     = ["192.168.0.192/26"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vmss.name
  service_endpoints    = ["Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vmss
  ]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}


#postgres flex private dns zone:

resource "azurerm_private_dns_zone" "postgres-tf" {
  name                = "example.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.vmss
  ]
}


#postgres flex server dns zone vnet link:

resource "azurerm_private_dns_zone_virtual_network_link" "tf-postgres" {
  name                  = "postgres-pvt-dns-zone-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgres-tf.name
  virtual_network_id    = azurerm_virtual_network.vmss.id
  resource_group_name   = var.resource_group_name
  registration_enabled = true
  depends_on = [
    azurerm_resource_group.vmss
  ]
}
