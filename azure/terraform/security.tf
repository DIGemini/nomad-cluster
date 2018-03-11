resource "azurerm_network_security_group" "cluster" {
  name                = "cluster-nsg"
  location            = "${var.azure_region}"
  resource_group_name = "${var.azure_resource_group}"
}

resource "azurerm_network_security_rule" "sshRule" {
  name                        = "allow-ssh"
  resource_group_name         = "${var.azure_resource_group}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"

  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "nomadRule" {
  name                        = "allow-nomad-allports"
  resource_group_name         = "${var.azure_resource_group}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"

  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "4646-4648"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "consulRule" {
  name                        = "allow-consul-allports"
  resource_group_name         = "${var.azure_resource_group}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"

  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"

  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_port_range      = "8300-8600"
  destination_address_prefix  = "*"
}

