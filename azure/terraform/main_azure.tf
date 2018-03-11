# virtual_machine
resource "azurerm_virtual_machine" "master" {
  name                  = "master-${count.index}"
  location              = "${var.azure_region}"
  resource_group_name   = "${var.azure_resource_group}"
  network_interface_ids = ["${element(azurerm_network_interface.master.*.id,count.index)}"]
  vm_size               = "${var.vm_size}"
  count                 = "${var.server_count}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
 # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name            = "osMasterDisk-${count.index}"
    caching         = "ReadWrite"
    create_option   = "FromImage"
    image_uri       = "https://${var.azure_storage_account}.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.${var.image_master_guid}.vhd"
    vhd_uri         = "https://${var.azure_storage_account}.blob.core.windows.net/images/packer-osDiskMaster-${count.index}.vhd"
    os_type         = "linux"
  }

  os_profile {
    computer_name   = "master-${count.index}"
    admin_username  = "${var.master_admin_username}"
    admin_password  = "${var.master_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "slave" {
  name          = "slave-${count.index}"
  location      = "${var.azure_region}"
  resource_group_name   = "${var.azure_resource_group}"
  network_interface_ids = ["${element(azurerm_network_interface.slave.*.id,count.index)}"]
  vm_size               = "${var.vm_size}"
  count                 = "${var.client_count}"
  depends_on            = ["azurerm_virtual_machine.master"]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name          = "mySlaveDisk-${count.index}"
    caching       = "ReadWrite"
    create_option = "FromImage"
    image_uri     = "https://${var.azure_storage_account}.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.${var.image_slave_guid}.vhd"
    vhd_uri       = "https://${var.azure_storage_account}.blob.core.windows.net/images/packer-osDiskSlave-${count.index}.vhd"
    os_type       = "linux"
  }

  os_profile {
    computer_name  = "slave-${count.index}"
    admin_username = "${var.slave_admin_username}"
    admin_password = "${var.slave_admin_password}"
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "server_public_ips" {
  value = ["${azurerm_public_ip.master.*.ip_address}"]
}

output "client_public_ips" {
  value = ["${azurerm_public_ip.slave.*.ip_address}"]
}