variable "vm_name" {
  type = list(string)
}
variable "rglocation" {
  type = list(string)
}
variable "subnet_id" {
  type = any
}
variable "resource_group_name" {
  type = string
}

variable "vm_type" {
  type = string
}


variable "NSG_id" {
  type = list(string)
}

variable "vmss_id_ubuntu" {
  type = list(string)
}
variable "vm_size" {
  type = string
}
variable "skuubuntu" {
  type = string
}
variable "skuwindows" {
  type = string
}
variable "azureuser" {
  type = string
}
# variable "azurepassword" {
#   type = any
# }

variable "keydata_path" {
  type = string
}
variable "azurekyvaulsecretname" {
  type = string
}
variable "keyvaultid" {
  type = string
}
variable "vmss_id" {
  type = list(string)
}
variable "number_of_instances" {
  type = number
}
variable "metric_name" {
  type = string
}
variable "threshold_greaterthan" {
  type = number
}
variable "directionrule1" {
  type = string
}
variable "threshold_lessthan" {
  type = number
}
variable "directionrule2" {
  type = string
}
variable "changecount_value_decrease" {
  type = number
}
variable "changecount_value_increase" {
 type = number
}
variable "address_poolid" {
  type = list(string)
}
variable "my_tags" {
  type = any
}
