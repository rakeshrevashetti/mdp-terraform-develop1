data "azurerm_public_ip" "ministation_pip" {
  name                 = "${azurerm_public_ip.ministation_pip.name}"
  resource_group_name  = "${azurerm_virtual_machine.ministation_vm.resource_group_name}"
}
