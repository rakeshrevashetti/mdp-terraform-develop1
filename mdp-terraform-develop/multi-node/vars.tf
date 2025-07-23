variable subscription_id {}
variable tenant_id {}
variable client_id {}
variable client_secret {}
variable "env_location" {
    description = "The region where resources will be created"
    default = "Central India"
}
variable "env_name" {}
variable "env_address" {}
variable "management_user" {}
variable "management_password" {}
variable "k8s_user" {}
variable "k8s_password" {}
variable "tags_value" {}
variable "lb_ports" {type = map(string)}
variable "fw_ports" {type = list(string)}
variable "k8s_node_vm_size" {}
variable "mgmnt_vm_size" {}
variable "mgmnt_osdisk_size" {}
variable "k8s_osdisk_size" {}
variable "k8snode_count" {}
variable "longhorndisks_count" {}
variable "longhorndisks_size" {}
variable "sku_version" {}
variable "os_offer" {}
variable "enable_peering_dev" {}
variable "enable_peering_jenkins" {}
variable "autoshutdown_time" {
    default = "1930"
}
variable "enable_autoshutdown" {
    default = true
}

provider "azurerm" {
    #version = "=1.44"
    subscription_id = "${var.subscription_id}"
    tenant_id = "${var.tenant_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    features {}
}
