output "vmss_id" {
  value = "${formatlist("%v",azurerm_windows_virtual_machine_scale_set.vmss.*.id)}"  
}
output "na" {
  value = azurerm_windows_virtual_machine_scale_set.vmss.*.id
}
output "vmss_id_ubuntu" {
  value = "${formatlist("%v",azurerm_linux_virtual_machine_scale_set.vmss_ubuntu.*.id)}"  
}

output "vmss_name_ubuntu" {
  value = "${formatlist("%v",azurerm_linux_virtual_machine_scale_set.vmss_ubuntu.*.name)}"  
}

