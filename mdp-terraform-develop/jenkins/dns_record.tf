data "azurerm_public_ip" "ministation_pip" {
  name                 = "${azurerm_public_ip.ministation_pip.name}"
  resource_group_name  = "${azurerm_virtual_machine.ministation_vm.resource_group_name}"
}


resource "azurerm_dns_a_record" "ministation_dnsa" {
  name                = "${var.resource_group_name}"
  zone_name           = "smart-mobility.alstom.com"
  resource_group_name = "amdp-dns"
  ttl                 = 300
  records             = ["${data.azurerm_public_ip.ministation_pip.ip_address}"]
}
