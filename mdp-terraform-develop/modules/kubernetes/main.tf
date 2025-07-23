resource "azurerm_availability_set" "amdp-avset" {
  name                         = "amdp-avset"
  location                     = "${var.k8s_location}"
  resource_group_name          = "${var.k8s_name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "lbpip" {
  name                         = "${var.k8s_name}-ip"
  location                     = "${var.k8s_location}"
  resource_group_name          = "${var.k8s_name}"
  allocation_method            = "Static"
}

resource "azurerm_lb" "lb" {
  resource_group_name = "${var.k8s_name}"
  name                = "${var.k8s_name}-lb"
  location            = "${var.k8s_location}"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = "${azurerm_public_ip.lbpip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "BackendPool1"
}

resource "azurerm_lb_rule" "lb_rule" {
  count                          = "${length(var.lb_ports)}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  name                           = "LBRule-${element(keys(var.lb_ports),count.index)}"
  protocol                       = "Tcp"
  frontend_port                  = "${element(keys(var.lb_ports),count.index)}"
  backend_port                   = "${lookup(var.lb_ports, "${element(keys(var.lb_ports),count.index)}")}"
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  enable_floating_ip             = false
  backend_address_pool_ids        = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
  depends_on                     = [azurerm_lb_probe.lb_probe]
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "tcpProbe"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 5
  number_of_probes    = 2
}
resource "azurerm_network_interface" "k8s-nodes" {
    count                        = "${var.k8snode_count}"
    name                         = "k8s-node${format("%02d", count.index+1)}"
    location                     = "${var.k8s_location}"
    resource_group_name          = "${var.k8s_name}"

    ip_configuration {
        name                              = "k8s-node${format("%02d", count.index+1)}"
        subnet_id                         = "${var.private_subnet_id}"
        private_ip_address_allocation     = "Static"
        private_ip_address                = "${cidrhost(var.subnet_private, count.index + 1 + 4)}" 
    }
    
    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }
}

resource "azurerm_network_interface_backend_address_pool_association" "k8s-nodes" {
  count                   = "${var.k8snode_count}"
  network_interface_id    = "${element(azurerm_network_interface.k8s-nodes.*.id, count.index)}"
  ip_configuration_name   = "k8s-node${format("%02d", count.index+1)}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.backend_pool.id}"
}

resource "azurerm_managed_disk" "longhorn_disks" {
    name                          = "longhorn${format("%02d", count.index+1)}"
    location                      = "${var.k8s_location}"
    resource_group_name           = "${var.k8s_name}"
    storage_account_type          = "Premium_LRS"
    create_option        = "Empty"
    disk_size_gb         = "${var.longhorndisks_size}"

    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }

    count = tonumber("${var.k8snode_count}") * tonumber("${var.longhorndisks_count}")
}

resource "azurerm_virtual_machine" "k8s-nodes" {
    name                           = "k8s-node${format("%02d", count.index+1)}"
    location                      = "${var.k8s_location}"
    resource_group_name           = "${var.k8s_name}"
    availability_set_id           = "${azurerm_availability_set.amdp-avset.id}"
    network_interface_ids         = ["${element(azurerm_network_interface.k8s-nodes.*.id, count.index)}"]
    vm_size                       = "${var.vm_size}"
    delete_os_disk_on_termination = true
    storage_os_disk {
        name              = "k8s-node${format("%02d", count.index+1)}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
        disk_size_gb      = "${var.k8s_osdisk_size}"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "${var.os_offer}"
        sku       = "${var.sku_version}"
        version   = "latest"
    }

    os_profile {
        computer_name = "k8s-node${format("%02d", count.index+1)}"
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
    count = "${var.k8snode_count}"
}

resource "azurerm_virtual_machine_data_disk_attachment" "longhorn_disks_attachement" {
    managed_disk_id    = azurerm_managed_disk.longhorn_disks.*.id[count.index]
    virtual_machine_id = azurerm_virtual_machine.k8s-nodes.*.id[ceil((count.index + 1) * 1.0 / var.longhorndisks_count) - 1]
    lun                = count.index + 10
    caching            = "ReadWrite"

    count = tonumber("${var.k8snode_count}") * tonumber("${var.longhorndisks_count}")
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "k8s-nodes" {
    virtual_machine_id = azurerm_virtual_machine.k8s-nodes.*.id[count.index]
    location           = "${var.k8s_location}"
    enabled            = "${var.enable_autoshutdown}"

    daily_recurrence_time = "${var.autoshutdown_time}"
    timezone              = "India Standard Time"

    notification_settings {
        enabled         = false
    }

    tags                  = {
        ms-resource-usage = "${var.tag_value}"
    }

    count = "${var.k8snode_count}"
}
