resource "azurerm_resource_group" "private" {
  name     = "${var.env_name}"
  location = "${var.env_location}"
}
resource "azurerm_network_security_group" "private" {
  name                = "${azurerm_resource_group.private.name}-security"
  location            = "${var.env_location}"
  resource_group_name = "${azurerm_resource_group.private.name}"
}

##Temporary rules - To be removed, access from outside to private should only be from public subnet
resource "azurerm_network_security_rule" "private1" {
  count                       = "${length(var.fw_ports)}"
  name                        = "Allow_${var.fw_ports[count.index]}"
  priority                    = "${(count.index + 10) * 100}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${var.fw_ports[count.index]}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.private.name}"
  network_security_group_name = "${azurerm_network_security_group.private.name}"
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.env_name}"
  location            = "${var.env_location}"
  resource_group_name = "${azurerm_resource_group.private.name}"
  address_space       = ["${var.env_address}"]

  tags                = {
    ms-resource-usage = "${var.tag_value}"
  }
}

resource "azurerm_subnet" "private" {
  name                 = "${var.env_name}"
  resource_group_name  = "${azurerm_resource_group.private.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefixes     = ["${var.subnet_private}"]
}

resource "azurerm_subnet" "bastion" {
  name                  = "AzureBastionSubnet"
  resource_group_name   = "${azurerm_resource_group.private.name}"
  virtual_network_name  = "${azurerm_virtual_network.network.name}"
  address_prefixes      = ["${var.AzureBastionSubnet}"]
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = "${azurerm_subnet.private.id}"
  network_security_group_id = "${azurerm_network_security_group.private.id}"
}

resource "azurerm_virtual_network_peering" "peering1" {
  count                        = "${var.enable_peering_dev}"
  name                         = "${azurerm_virtual_network.network.name}-dev2"
  resource_group_name          = "${azurerm_resource_group.private.name}"
  virtual_network_name         = "${azurerm_virtual_network.network.name}"
  remote_virtual_network_id    = "/subscriptions/21b61287-b2bd-4767-b872-b4d447d90553/resourceGroups/amdp-development2/providers/Microsoft.Network/virtualNetworks/amdp-development2-vnet"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "peering2" {
  count                        = "${var.enable_peering_dev}"
  name                         = "dev2-${azurerm_virtual_network.network.name}"
  resource_group_name          = "amdp-development2"
  virtual_network_name         = "amdp-development2-vnet"
  remote_virtual_network_id    = "${azurerm_virtual_network.network.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "peeringjen1" {
  count                        = "${var.enable_peering_jenkins}"
  name                         = "${azurerm_virtual_network.network.name}-jenkins"
  resource_group_name          = "${azurerm_resource_group.private.name}"
  virtual_network_name         = "${azurerm_virtual_network.network.name}"
  remote_virtual_network_id    = "/subscriptions/21b61287-b2bd-4767-b872-b4d447d90553/resourceGroups/amdp-devops/providers/Microsoft.Network/virtualNetworks/amdp-devops"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "peeringjen2" {
  count                        = "${var.enable_peering_jenkins}"
  name                         = "jenkins-${azurerm_virtual_network.network.name}"
  resource_group_name          = "amdp-devops"
  virtual_network_name         = "amdp-devops"
  remote_virtual_network_id    = "${azurerm_virtual_network.network.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                = "${join("", split("-", "${var.env_name}"))}"
    resource_group_name = "${azurerm_resource_group.private.name}"
    location            = "${var.env_location}"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }
}
