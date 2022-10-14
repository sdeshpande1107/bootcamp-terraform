terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.26.0"
    }
  }
}

#Creating a resource group:

resource "azurerm_resource_group" "terraform" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Providing random passwords for availibility set machines and db-server :

resource "random_password" "availibility-set-machines-password" {
  length = 14
  special = true
}

resource "random_password" "db-server-password" {
  length = 14
  special = true
}
 