resource "azurerm_virtual_machine" "ministation_vm" {
  name                  = "${azurerm_resource_group.ministation_rg.name}-vm0"
  location              = "${azurerm_resource_group.ministation_rg.location}"
  resource_group_name   = "${azurerm_resource_group.ministation_rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ministation_nic.id}"]
  vm_size               = "Standard_D2S_V3"

    storage_os_disk {
      name              = "${azurerm_resource_group.ministation_rg.name}-osdisk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Premium_LRS"
      disk_size_gb      = 60
    } 

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    storage_data_disk {
        name            = "${azurerm_resource_group.ministation_rg.name}-datadisk-0"
        caching         = "ReadOnly"
        create_option   = "Empty"
        lun             = 0
        disk_size_gb    = 1000
    }

    os_profile {
        computer_name  = "${azurerm_resource_group.ministation_rg.name}"
        admin_username = "${var.username}"
        admin_password = "${var.password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
  }
}
