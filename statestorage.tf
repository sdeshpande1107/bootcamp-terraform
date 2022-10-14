# Creating backend storage :

terraform {
  backend "azurerm" {
    resource_group_name  = "storage-account"
    storage_account_name = "terraformstorage1212"
    container_name       = "storagecontainer-tf-vmss"
    key                  = "terraform.tfstate"
  }
}


resource "azurerm_resource_group" "storage-account" {
  name     = "storage-account"
  location = "East US"
}


resource "azurerm_storage_account" "terraformstorage1212" {
  name                     = "terraformstorage1212"
  resource_group_name      = azurerm_resource_group.storage-account.name
  location                 = azurerm_resource_group.storage-account.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "storagecontainer-tf" {
  name                  = "storagecontainer-tf-vmss"
  storage_account_name  = azurerm_storage_account.terraformstorage1212.name
  container_access_type = "blob"
}



