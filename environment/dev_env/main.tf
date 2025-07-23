module "network" {
  source              = "../../modules/network"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "management" {
  source              = "../../modules/management"
  location            = var.location
  environment         = var.environment
  resource_group_name = var.resource_group_name
}

module "kubernetes" {
  source              = "../../modules/kubernetes"
  cluster_name        = var.cluster_name
  location            = var.location
  subnet_id           = module.network.subnet_id
  resource_group_name = var.resource_group_name
}
