resource "azurerm_virtual_network" "cluster" {
  name                = "cluster-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
}

resource "azurerm_subnet" "cluster" {
  name                 = "cluster-subnet"
  resource_group_name  = "${azurerm_resource_group.cluster.name}"
  virtual_network_name = "${azurerm_virtual_network.cluster.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "master" {
  name                         = "master-pip"
  location                     = "${var.azure_region}"
  resource_group_name          = "${azurerm_resource_group.cluster.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30

  tags {
    environment = "test"
  }
}

resource "azurerm_public_ip" "slave" {
  name                         = "slave-pip"
  location                     = "${var.azure_region}"
  resource_group_name          = "${azurerm_resource_group.cluster.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30

  tags {
    environment = "test"
  }
}

resource "azurerm_network_interface" "master" {
  name                = "master-interface"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  network_security_group_id = "${azurerm_network_security_group.cluster.id}"
  
  ip_configuration {
    name                          = "master-ipconfiguration"
    subnet_id                     = "${azurerm_subnet.cluster.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.master.id}"
  }
}

resource "azurerm_network_interface" "slave" {
  name                = "slave-interface"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  network_security_group_id = "${azurerm_network_security_group.cluster.id}"

  ip_configuration {
    name                          = "slave-ipconfiguration"
    subnet_id                     = "${azurerm_subnet.cluster.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.slave.id}"
  }
}