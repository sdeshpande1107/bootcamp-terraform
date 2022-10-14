# Output file: 

 output "availibility-set-machines-password" {
  value = random_password.availibility-set-machines-password.result
  sensitive = true
}

output "db-server-password" {
  value = random_password.db-server-password.result
  sensitive = true
}

