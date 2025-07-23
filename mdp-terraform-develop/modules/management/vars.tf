variable "management_name" {
  description = "resource group name"
}

variable "management_location" {
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
variable "mgmnt_osdisk_size" {
  description = "management Os Disk size "  
}

variable "sku_version" {
  description = "OS version"
}

variable "os_offer" {
  description = "OS provider"
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
