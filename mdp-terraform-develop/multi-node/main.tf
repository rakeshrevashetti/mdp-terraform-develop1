module "network" {
  source = "../modules/network"

  env_location = "${var.env_location}"
  env_name = "${var.env_name}"
  env_address = "${var.env_address}/16"
  AzureBastionSubnet = "${cidrsubnet("${var.env_address}/16", 11, 3)}"
  subnet_private = "${cidrsubnet("${var.env_address}/16", 8, 2)}"
  tag_value = "${var.tags_value}"
  fw_ports = "${var.fw_ports}"
  enable_peering_dev ="${var.enable_peering_dev}"
  enable_peering_jenkins = "${var.enable_peering_jenkins}"
}
module "management" {
  source = "../modules/management"

  management_name       = "${module.network.env_name}"
  management_location   = "${module.network.env_location}"
  private_sgp_id        = "${module.network.private_sgp_id}"
  private_subnet_id     = "${module.network.subnet_private_id}"
  vm_size               = "${var.mgmnt_vm_size}"
  storage_uri           = "${module.network.diag_account_uri}"
  user_name             = "${var.management_user}"
  user_pass             = "${var.management_password}"
  tag_value             = "${var.tags_value}"
  mgmnt_osdisk_size     = "${var.mgmnt_osdisk_size}"
  sku_version           = "${var.sku_version}"
  os_offer              = "${var.os_offer}"
  subnet_private        = "${cidrsubnet("${var.env_address}/16", 8, 2)}"
  enable_autoshutdown   = "${var.enable_autoshutdown}"
  autoshutdown_time     = "${var.autoshutdown_time}"
  
}


module "kubernetes" {
  source = "../modules/kubernetes"

  k8s_name              = "${module.network.env_name}"
  k8s_location          = "${module.network.env_location}"
  private_sgp_id        = "${module.network.private_sgp_id}"
  private_subnet_id     = "${module.network.subnet_private_id}"
  vm_size               = "${var.k8s_node_vm_size}"
  storage_uri           = "${module.network.diag_account_uri}"
  user_name             = "${var.k8s_user}"
  user_pass             = "${var.k8s_password}"
  tag_value             = "${var.tags_value}"
  lb_ports              = "${var.lb_ports}"
  k8s_osdisk_size       = "${var.k8s_osdisk_size}"
  k8snode_count         = "${var.k8snode_count}"
  longhorndisks_count   = "${var.longhorndisks_count}"
  longhorndisks_size    = "${var.longhorndisks_size}"
  sku_version           = "${var.sku_version}"
  os_offer              = "${var.os_offer}"
  env_name              = "${var.env_name}"
  subnet_private        = "${cidrsubnet("${var.env_address}/16", 8, 2)}"
  enable_autoshutdown   = "${var.enable_autoshutdown}"
  autoshutdown_time     = "${var.autoshutdown_time}"
}
