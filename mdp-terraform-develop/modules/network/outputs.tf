output "env_location" {
  value = "${azurerm_resource_group.private.location}"
}

output "env_name" {
  value = "${azurerm_virtual_network.network.name}"
}

output "subnet_private_id" {
  value = "${azurerm_subnet.private.id}"
}

output "subnet_private" {
  value = "${var.subnet_private}"
}

output "diag_account_uri" {
  value = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
}

output "private_sgp_id" {
  value = "${azurerm_network_security_group.private.id}"
}







