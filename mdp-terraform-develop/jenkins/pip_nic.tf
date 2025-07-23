resource "azurerm_public_ip" "ministation_pip" {
  name                          = "${azurerm_resource_group.ministation_rg.name}"
  location                      = "${azurerm_resource_group.ministation_rg.location}"
  resource_group_name           = "${azurerm_resource_group.ministation_rg.name}"
  public_ip_address_allocation  = "dynamic"
}

resource "azurerm_network_interface" "ministation_nic" {
  name                          = "${azurerm_public_ip.ministation_pip.name}"
  location                      = "${azurerm_resource_group.ministation_rg.location}"
  resource_group_name           = "${azurerm_resource_group.ministation_rg.name}"
  network_security_group_id     = "${var.security_group_ID}"


  ip_configuration {
      name                              = "${azurerm_public_ip.ministation_pip.name}"
      subnet_id                         = "${azurerm_subnet.ministation_subnet.id}"
      private_ip_address_allocation     = "dynamic"
      public_ip_address_id              = "${azurerm_public_ip.ministation_pip.id}"
  }
}