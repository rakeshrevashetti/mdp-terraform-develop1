variable "k8s_name" {
  description = "resource group name"
}

variable "k8s_location" {
  description = "location"
}

variable "private_sgp_id" {
  description = "network security group id"
}

variable "private_subnet_id" {
  description = "bastion subnet id"
}


variable "vm_size" {
  description = "virtual machine size"
}

variable "storage_uri" {
  description = "diagnostic storage account"
}

variable "user_name" {
  description ="user name"
}

variable "user_pass" {
  description = "user password"
}

variable "tag_value" {
  description = "Tags value"
}

variable "lb_ports" {
  description = "list of ports to open on loadbalancer"
  type = map(string)
  #default = {
  #  "443" = "443"
  #}
}

variable "manageddisk" {
  type = string
  default = "Standard_LRS"
}


variable "k8s_osdisk_size" {
  description = "k8s node Os Disk Size"
}

variable "k8snode_count" {
  description = " k8s node count"
}

variable "longhorndisks_count" {
  description = "longhorn disks per VM count"
}

variable "longhorndisks_size" {
  description = "longhorn disks size in GB"
}

variable "sku_version" {
  description = "OS version"
}

variable "os_offer" {
  description = "OS provider"
}

variable "env_name" {
  description = "name of the environment"
}

variable "subnet_private" {
  description = "Private subnet address where kubernetes and management VM reside"
}

variable "enable_autoshutdown" {
  description = "Turn on autoshutdown of VM"
}

variable "autoshutdown_time" {
  description = "Time of autoshutdown of VM in UTC"
}
