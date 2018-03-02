resource "azurerm_network_security_group" "cluster" {
  name                = "cluster-nsg"
  location            = "${azurerm_resource_group.cluster.location}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
}

resource "azurerm_network_security_rule" "sshRule" {
  name                        = "SSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.cluster.name}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"
}

resource "azurerm_network_security_rule" "httpRule" {
  name                        = "HTTP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.cluster.name}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"
}

resource "azurerm_network_security_rule" "httpsRule" {
  name                        = "HTTPS"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.cluster.name}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"
}

resource "azurerm_network_security_rule" "httpsRule2" {
  name                        = "HTTPS2"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.cluster.name}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"
}

resource "azurerm_network_security_rule" "consulruleinbound" {
  name                        = "HTTP-HTTPS-Consul"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "8300-8600"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.cluster.name}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"
}

resource "azurerm_network_security_rule" "denyRule" {
  name                        = "deny-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.cluster.name}"
  network_security_group_name = "${azurerm_network_security_group.cluster.name}"
}