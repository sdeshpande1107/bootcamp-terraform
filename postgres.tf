# Creating postgresql flexible server :

resource "azurerm_postgresql_flexible_server" "psqlflexibleserver" {
  name                   = "psqlflexibleserver"
  resource_group_name    = azurerm_resource_group.vmss.name
  location               = azurerm_resource_group.vmss.location
  version                = "14"
  delegated_subnet_id    = azurerm_subnet.vmss-postgres-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres-tf.id
  administrator_login    = var.db_username
  administrator_password = var.db_password
  #zone                   = "1"

  storage_mb = 32768

  sku_name   = "GP_Standard_D4s_v3"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.tf-postgres, azurerm_subnet.vmss-postgres-subnet]
}

resource "azurerm_postgresql_flexible_server_configuration" "backslash_quote" {
  name      = "backslash_quote"
  server_id = azurerm_postgresql_flexible_server.psqlflexibleserver.id
  value     = "off"
  depends_on = [
    azurerm_subnet.vmss-postgres-subnet
  ]
}
