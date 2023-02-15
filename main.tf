 data "azurerm_key_vault_secret" "azurepassword" {
   name         = var.azurekyvaulsecretname 
   key_vault_id = var.keyvaultid
 }



resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  count                  = var.vm_type == "Windows" ? length(var.vm_name) : 0
  name                = element(var.vm_name, count.index )
  resource_group_name = var.resource_group_name
  location            = element(var.rglocation, count.index ) 
  sku                 =  var.vm_size 
  instances           = var.number_of_instances
  admin_password      = data.azurerm_key_vault_secret.azurepassword.value
  admin_username      = var.azureuser
  tags = merge(var.my_tags, {
    service = element(var.vm_name, count.index)
    
  })
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       =  var.skuwindows
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = length(var.vm_name)
    primary = true

    ip_configuration {
      name      = length(var.subnet_id)
      primary   = true
      subnet_id = element( var.subnet_id, count.index)
      load_balancer_backend_address_pool_ids = count.index== 7 ? element(var.address_poolid[0])  : null 
    }
    network_security_group_id = element(var.NSG_id, count.index )
  }
}

#############################################################################################################

resource "azurerm_monitor_autoscale_setting" "main" {
  count = var.vm_type == "Windows" ? length(var.vmss_id) - 2 : 0
  name                = "autoscale-config-${count.index + 2}"
  resource_group_name = var.resource_group_name
  location            = element(var.rglocation, count.index + 2 ) 
  target_resource_id  =  element( var.vmss_id, count.index + 2) 

  profile {
    name = "AutoScale"

    capacity {
      default = 3
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        =  var.metric_name 
        metric_resource_id = element( var.vmss_id, count.index + 2 ) 
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.threshold_greaterthan 
      }

      scale_action {
        direction = var.directionrule1
        type      = "ChangeCount"
        value     = var.changecount_value_increase 
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = var.metric_name 
       metric_resource_id =  element( var.vmss_id, count.index + 2) 
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.threshold_lessthan
      }

      scale_action {
        direction = var.directionrule2
        type      = "ChangeCount"
        value     = var.changecount_value_decrease
        cooldown  = "PT1M"
      }
    }
  }
}

#############################################   Ubuntu   @@@@#########################################



resource "azurerm_linux_virtual_machine_scale_set" "vmss_ubuntu" {
  count                  = var.vm_type == "Ubuntu" ? length(var.vm_name) : 0
  name                = element(var.vm_name, count.index )
  resource_group_name = var.resource_group_name
  location            = element(var.rglocation, count.index ) 
  sku                 =  var.vm_size 
  instances           = var.number_of_instances
  admin_password      = data.azurerm_key_vault_secret.azurepassword.value
  admin_username      = var.azureuser
    tags = merge(var.my_tags, {
    service = element(var.vm_name, count.index)
    
  })
  admin_ssh_key {
    username   = var.azureuser
    public_key = file("${var.keydata_path}")     
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       =  var.skuubuntu
    version   = "20.04.202212130"

      
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  network_interface {
    name    = length(var.vm_name)
    primary = true

    ip_configuration {
      name      = length(var.subnet_id)
      primary   = true
      subnet_id = element( var.subnet_id, count.index)
     load_balancer_backend_address_pool_ids = count.index == 7 ? [var.address_poolid[0]] : [] 
      }  
    network_security_group_id = element(var.NSG_id, count.index )
  }
  
}

###########@@@@@@@@@@@@@@@@@@@@@@@################@@@@@@@@@@@@@@@@@@@@@@@@@@

resource "azurerm_monitor_autoscale_setting" "ubuntu" {
  count = length(var.vmss_id_ubuntu) - 2
  name                = "autoscale-configg-${count.index + 2}"
  resource_group_name = var.resource_group_name
  location            = element(var.rglocation, count.index + 2) 
  target_resource_id  =  element( var.vmss_id_ubuntu, count.index + 2) 

  profile {
    name = "AutoScalee"

    capacity {
      default = 3
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = var.metric_name 
        metric_resource_id =  element( var.vmss_id_ubuntu, count.index + 2)  
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.threshold_greaterthan 
      }

      scale_action {
        direction = var.directionrule1 
        type      = "ChangeCount"
        value     = var.changecount_value_increase 
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = var.metric_name 
       metric_resource_id =  element( var.vmss_id_ubuntu, count.index + 2)  
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.threshold_lessthan 
      }

      scale_action {
        direction = var.directionrule2 
        type      = "ChangeCount"
        value     = var.changecount_value_decrease 
        cooldown  = "PT1M"
      }
    }
  }
}


####################

