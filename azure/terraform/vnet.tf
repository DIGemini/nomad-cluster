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

# Setting network resources for Master
resource "azurerm_public_ip" "master" {
  count                         = "${var.server_count}"
  name                          = "master-pip-${count.index}"
  location                      = "${var.azure_region}"
  resource_group_name           = "${azurerm_resource_group.cluster.name}"
  #public_ip_address_allocation = "Dynamic"
  public_ip_address_allocation  = "static"
}

resource "azurerm_network_interface" "master" {
  count                           = "${var.server_count}"
  name                            = "master-interface-${count.index}"
  location                        = "${var.azure_region}"
  resource_group_name             = "${azurerm_resource_group.cluster.name}"
  network_security_group_id       = "${azurerm_network_security_group.cluster.id}"

  ip_configuration {
    name                          = "master-ipc"
    subnet_id                     = "${azurerm_subnet.cluster.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.master.*.id,count.index)}"
  }

  tags {
    ConsulAutoJoin = "auto-join"
  }
}

# Setting network resources for Slave
resource "azurerm_public_ip" "slave" {
  count                         = "${var.client_count}"
  name                          = "slave-pip-${count.index}"
  location                      = "${var.azure_region}"
  resource_group_name           = "${azurerm_resource_group.cluster.name}"
  #public_ip_address_allocation = "Dynamic"
  public_ip_address_allocation  = "static"
}

resource "azurerm_network_interface" "slave" {
  count                           = "${var.client_count}"
  name                            = "slave-interface-${count.index}"
  location                        = "${var.azure_region}"
  resource_group_name             = "${azurerm_resource_group.cluster.name}"
  network_security_group_id       = "${azurerm_network_security_group.cluster.id}"

  ip_configuration {
    name                          = "slave-ipc"
    subnet_id                     = "${azurerm_subnet.cluster.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.slave.*.id,count.index)}"
  }

  tags {
    ConsulAutoJoin = "auto-join"
  }
}