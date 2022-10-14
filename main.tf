#Creating resource group :

resource "azurerm_resource_group" "vmss" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Generating random passwords: 

resource "random_password" "admin-password-vmss" {
  length  = 10
  min_lower = 3
  min_numeric = 3
  min_special = 3
  special = true

}

resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

