variable "resource_group_name" {
  default     = "Project-1-AvailibilitySet"
  description = "resource group name"
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of resource group"
}

variable "vnet_name" {
  default     = "vnet"
  description = "Virtual Network name for weight tracker with load balancer and db vm project"
}

variable "resource_vm_count" {
  default     = 3
  description = "number of resources to be created"
}

variable "backendport" {
  default = 8080
  description = "Backend port of application"
}

variable "sshport" {
   default = 22
   description = "Port for ssh" 
}
