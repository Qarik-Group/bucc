# vars needed for bucc flags (which are included via common.sh)
output "director__concourse_domain" {
  value = "${azurerm_public_ip.concourse.ip_address}"
}

output "director__load_balancer" {
  value = "${azurerm_lb.concourse.name}"
}

# add vault port for jumpbox
resource "azurerm_network_security_rule" "vault" {
  name                        = "${var.env_id}-vault"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8200"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.bosh.name}"
  network_security_group_name = "${azurerm_network_security_group.bosh.name}"
}
