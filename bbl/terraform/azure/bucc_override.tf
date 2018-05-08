# open port 8443 for uaa authentication
resource "azurerm_network_security_rule" "uaa-https" {
  name                        = "${var.env_id}-uaa-https"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.bosh.name}"
  network_security_group_name = "${azurerm_network_security_group.bosh.name}"
}

resource "azurerm_lb_rule" "uaa-https" {
  name                = "${var.env_id}-uaa-https"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.concourse.id}"

  frontend_ip_configuration_name = "${var.env_id}-concourse-frontend-ip-configuration"
  protocol                       = "TCP"
  frontend_port                  = 8443
  backend_port                   = 8443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.concourse.id}"
  probe_id                = "${azurerm_lb_probe.uaa-https.id}"
}

resource "azurerm_lb_probe" "uaa-https" {
  name                = "${var.env_id}-uaa-https"
  resource_group_name = "${azurerm_resource_group.bosh.name}"
  loadbalancer_id     = "${azurerm_lb.concourse.id}"
  protocol            = "TCP"
  port                = 8443
}

# vars needed for bucc flags (which are included via common.sh)
output "director__concourse_domain" {
  value = "${azurerm_public_ip.concourse.ip_address}"
}

output "director__load_balancer" {
  value = "${azurerm_lb.concourse.name}"
}
