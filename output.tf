output "vmss_public_ip" {
  value = azurerm_public_ip.vmss-public-ip.fqdn
}

output "db-machine-password" {
  value     = random_password.db-machine-password.result
  sensitive = true
}

output "admin-password-for-vmss" {
  value     = random_password.admin-password-vmss.result
  sensitive = true
}