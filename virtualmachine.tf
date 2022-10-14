# Creating availibility set: 

resource "azurerm_availability_set" "avset" {
  name                = "avset"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}


#creating virtual machines: 

resource "azurerm_linux_virtual_machine" "app-vm" {
  count               = var.resource_vm_count
  name                = "vm-${count.index}"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = random_password.availibility-set-machines-password.result
  availability_set_id = azurerm_availability_set.avset.id
  network_interface_ids           = [element(azurerm_network_interface.nic.*.id, count.index)]
  disable_password_authentication = false
  depends_on = [
    azurerm_availability_set.avset
  ]

  os_disk {
    name                 = "app-disk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

#create virtual machine for postgres DB: 

resource "azurerm_virtual_machine" "postgres-server" {
  name                  = "db-server"
  location              = azurerm_resource_group.terraform.location
  resource_group_name   = azurerm_resource_group.terraform.name
  network_interface_ids = [azurerm_network_interface.nic-postgres.id]
  vm_size               = "Standard_B1s"

  os_profile {
    computer_name  = "db-server"
    admin_username = "db-server"
    admin_password = random_password.db-server-password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_os_disk {
    name              = "app-disk-postgres"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "30"
  }
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}
