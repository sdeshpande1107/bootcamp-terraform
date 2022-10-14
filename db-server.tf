#Creating virtual machine for postgres DB :


resource "azurerm_virtual_machine" "db-machine" {
  name                  = "db-machine"
  location              = azurerm_resource_group.vmss.location
  resource_group_name   = azurerm_resource_group.vmss.name
  network_interface_ids = [azurerm_network_interface.db-nic.id]
  vm_size               = "Standard_B1s"

  os_profile {
    computer_name  = "db-machine"
    admin_username = var.admin_user
    admin_password = random_password.db-machine-password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_os_disk {
    name              = "db-machine-disk"
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