resource "azurerm_network_interface" "management" {
    name                          = "management"
    location                      = "${var.management_location}"
    resource_group_name           = "${var.management_name}"
      
    ip_configuration {
        name                              = "${var.management_name}"
        subnet_id                         = "${var.private_subnet_id}"
        private_ip_address_allocation     = "Static"
        private_ip_address                = "${cidrhost(var.subnet_private, 4)}" 

    }
    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }
}

resource "azurerm_virtual_machine" "management" {
    name                  = "management"
    location              = "${var.management_location}"
    resource_group_name   = "${var.management_name}"
    network_interface_ids = ["${azurerm_network_interface.management.id}"]
    vm_size               = "${var.vm_size}"
    delete_os_disk_on_termination = true

    storage_os_disk {
        name              = "management-osdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
        disk_size_gb     = "${var.mgmnt_osdisk_size}"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "${var.os_offer}"
        sku       = "${var.sku_version}"
        version   = "latest"
    }

    os_profile {
        computer_name  = "management"
        admin_username = "${var.user_name}"
        admin_password = "${var.user_pass}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = "${var.storage_uri}"
    }

    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "management" {
    virtual_machine_id = azurerm_virtual_machine.management.id
    location           = "${var.management_location}"
    enabled            = "${var.enable_autoshutdown}"

    daily_recurrence_time = "${var.autoshutdown_time}"
    timezone              = "India Standard Time"

    notification_settings {
        enabled         = false
    }

    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }
}
