# Creating resource group :

resource "azurerm_resource_group" "vmss" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}


# Defining random passwords for both scale set machines and db server : 

resource "random_password" "db-machine-password" {
  length  = 14
  special = true

}

resource "random_password" "admin-password-vmss" {
  length  = 14
  special = true

}

resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}