resource "azurerm_storage_account" "ministation_diagnostics" {
    name                        = "${join("", split("-", "${var.resource_group_name}"))}"
    resource_group_name         = "${azurerm_resource_group.ministation_rg.name}"
    location                    = "${azurerm_resource_group.ministation_rg.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}


