output "public_ip" {
  description = "Adresse IP publique de l’instance"
  value       = oci_core_instance.vm.public_ip
}

output "ssh_private_key" {
  description = "Clé privée SSH"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  description = "Clé publique SSH"
  value       = tls_private_key.ssh_key.public_key_openssh
  sensitive   = true
}
