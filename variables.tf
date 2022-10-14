variable "location" {
  description = "The location where resources will be created"
  default     = "West US"
  type        = string
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {
    environment = "staging"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "Project-3-ManagedPostgreSQL"
  type        = string
}


variable "azurerm_virtual_network" {
  description = "The name of the virtual network in which the resources will be created"
  default     = "VMSSnet"
  type        = string
}


variable "availability_zone_names" {
  description = "The name of the virtual network in which the resources will be created"
  default     = ["eastus"]
  type        = list(string)
}

variable "application_port" {
  description = "The port that you want to expose to the external load balancer"
  default     = 8080
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
  default     = "azureuser"
}


variable "resource_vm_count" {
  default     = 3
  description = "number of resources to be created"
}

variable "sshport" {
  default = 22
  description = "default ssh port"
  
}

variable "db_username" {
  default = "pgadmin"
  
}

variable "db_password" {
  default = "postTHEgres!@#"
  
}
