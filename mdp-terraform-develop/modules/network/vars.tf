variable "env_location" {
  description = "Location of VNET"
}
variable "env_name" {
  description = "Virtual network Name"  
}
variable "env_address" {
  description = "Virtual network address"
}

variable "AzureBastionSubnet" {
  description = " Azure Bastion Subnet address"  
}

variable "subnet_private" {
  description = "Private subnet address where kubernetes and management VM reside"
}


variable "tag_value" {
  description = "Tags value"
}

variable "fw_ports" {
  description = "ports to open on firewall"
  type = list(string)

}

variable "enable_peering_dev" {
  description = "dev peering"
}

variable "enable_peering_jenkins" {
  description = "jenkins peering"
}
