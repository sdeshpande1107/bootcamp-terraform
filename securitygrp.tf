#create public network security group and rules: 

resource "azurerm_network_security_group" "tf-public-nsg" {
  name                = "public-nsg"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name

  security_rule {
    access                     = "Allow"
    description                = "AllowSSH"
    destination_address_prefix = "*"
    source_address_prefixes    = ["14.141.60.58", "103.51.72.254", "182.72.58.210"]
    direction                  = "Inbound"
    name                       = "AllowSSHInBound"
    priority                   = 110
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
  }
  security_rule {
    access                     = "Allow"
    description                = "AllowWebapp"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
    direction                  = "Inbound"
    name                       = "AllowWebAppInBound"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.application_port
  }

  
  security_rule {
    access                     = "Deny"
    description                = "Deny all ports"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "DenyAll"
    priority                   = 510
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
  } 
}

#create private network security group and rules: 

resource "azurerm_network_security_group" "tf-private-nsg" {
  name                = "private-nsg"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name

  security_rule {
    access                     = "Allow"
    description                = "AllowSSH"
    destination_address_prefix = "*"
    source_address_prefixes    = ["10.0.2.0/24"]
    direction                  = "Inbound"
    name                       = "AllowSSHInBound"
    priority                   = 110
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
  }

  security_rule {
    access                     = "Allow"
    description                = "AllowPostgres"
    destination_address_prefix = "*"
    source_address_prefixes    = ["10.0.2.0/24"]
    direction                  = "Inbound"
    name                       = "AllowPostgresInBound"
    priority                   = 120
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 5432
  }

  
  security_rule {
    access                     = "Deny"
    description                = "Deny all ports"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "DenyAll"
    priority                   = 500
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
  } 
}



#Creating network interface : 

resource "azurerm_network_interface" "network-interface" {
  count               = 3
  name                = "app-vm-${count.index}-nic"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name

  ip_configuration {
    name                          = "app-vm-${count.index}-nic"
    subnet_id                     = azurerm_subnet.vmss-public-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Creating network interface for postgres vm:

resource "azurerm_network_interface" "db-nic" {
  name                = "db-nic"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name

  ip_configuration {
    name                          = "db-nic"
    subnet_id                     = azurerm_subnet.vmss-private-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Connecting security group to public subnet: 

resource "azurerm_subnet_network_security_group_association" "tf-public-nsg-association" {
  subnet_id                 = azurerm_subnet.vmss-public-subnet.id
  network_security_group_id = azurerm_network_security_group.tf-public-nsg.id
}

#Connecting security group to priate subnet: 

resource "azurerm_subnet_network_security_group_association" "tf-private-nsg-association" {
  subnet_id                 = azurerm_subnet.vmss-private-subnet.id
  network_security_group_id = azurerm_network_security_group.tf-private-nsg.id
}