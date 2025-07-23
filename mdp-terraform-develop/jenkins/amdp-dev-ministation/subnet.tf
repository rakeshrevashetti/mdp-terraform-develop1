resource "azurerm_resource_group" "ministation_rg" {
  location      = "${var.location}"
  name          = "${var.resource_group_name}"
}

resource "azurerm_subnet" "ministation_subnet" {
  name                  = "${azurerm_resource_group.ministation_rg.name}"
  resource_group_name   = "${var.vnet_name}"
  virtual_network_name  = "${var.vnet_name}"
  address_prefix        = "${var.subnet_cidr}"
}

