variable "nic_name" {}
variable "location" {}
variable "resource_group_name" {}

variable "vm_name" {}
# variable "admin_username" {}
# variable "admin_password" {}

variable "subnet_name" {}
variable "virtual_network_name" {}

variable "public_ip_name" {}

variable "nsg_name" {
  type = string
}

variable "nsg_id" {
  type = string
}