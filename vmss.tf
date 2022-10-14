resource "azurerm_public_ip" "vmss-public-ip" {
  name                = "vmss-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  allocation_method   = "Static"
  domain_name_label   = random_string.fqdn.result
  tags                = var.tags
}

resource "azurerm_lb" "vmss" {
  name                = "vmss-lb"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss-public-ip.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.vmss.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
  loadbalancer_id = azurerm_lb.vmss.id
  name            = "health-probe"
  port            = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  loadbalancer_id                = azurerm_lb.vmss.id
  name                           = "Allowing-Application-In"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.vmss.id
}

resource "azurerm_lb_nat_pool" "nat-pool" {
  resource_group_name            = azurerm_resource_group.vmss.name
  loadbalancer_id                = azurerm_lb.vmss.id
  name                           = "NAT-Pool"
  protocol                       = "Tcp"
  frontend_port_start            = 3000
  frontend_port_end              = 3019
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_linux_virtual_machine_scale_set" "scale-set-machines" {
  name                            = "scale-set-machines"
  resource_group_name             = azurerm_resource_group.vmss.name
  location                        = var.location
  sku                             = "Standard_B1ms"
  instances                       = var.resource_vm_count
  admin_username                  = var.admin_user
  admin_password                  = random_password.admin-password-vmss.result
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  network_interface {
    name                      = "public_nic"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.tf-public-nsg.id
    ip_configuration {
      name                                   = "nic-bonus"
      primary                                = true
      version                                = "IPv4"
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.nat-pool.id]
      subnet_id                              = azurerm_subnet.vmss-public-subnet.id
    }
  }

  health_probe_id = azurerm_lb_probe.vmss.id

  data_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 16
    lun                  = "30"
  }
}
