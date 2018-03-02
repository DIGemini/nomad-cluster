resource "azurerm_resource_group" "cluster" {
  name     = "${var.azure_resource_group}"
  location = "${var.azure_region}"
}

resource "azurerm_virtual_machine" "master" {
  name          = "master"
  location      = "${var.azure_region}"
  resource_group_name   = "${azurerm_resource_group.cluster.name}"
  network_interface_ids = ["${azurerm_network_interface.master.id}"]
  vm_size               = "${var.vm_size}"

  storage_os_disk {
    name          = "mymasterdisk"
    create_option = "FromImage"
    image_uri     = "https://${var.azure_storage_account}.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.${var.image_master_guid}.vhd"
    vhd_uri       = "https://${var.azure_storage_account}.blob.core.windows.net/images/packer-osDiskMaster.vhd"
    os_type       = "linux"
  }

  os_profile {
    computer_name  = "master"
    admin_username = "${var.master_admin_username}"
    admin_password = "${var.master_admin_password}"
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "test"
  }
}

resource "azurerm_virtual_machine" "slave" {
  name          = "slave"
  location      = "${var.azure_region}"
  resource_group_name   = "${azurerm_resource_group.cluster.name}"
  network_interface_ids = ["${azurerm_network_interface.slave.id}"]
  vm_size               = "${var.vm_size}"

  storage_os_disk {
    name          = "myslavedisk"
    create_option = "FromImage"
    image_uri     = "https://${var.azure_storage_account}.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.${var.image_slave_guid}.vhd"
    vhd_uri       = "https://${var.azure_storage_account}.blob.core.windows.net/images/packer-osDiskSlave.vhd"
    os_type       = "linux"
  }

  os_profile {
    computer_name  = "slave"
    admin_username = "${var.slave_admin_username}"
    admin_password = "${var.slave_admin_password}"
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}
