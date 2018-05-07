# open port 8443 for uaa authentication
output "director__tags" {
  value = [
    "${google_compute_firewall.bosh-director.name}",
    "${var.env_id}-concourse-open",
    "concourse",
  ]
}

resource "google_compute_firewall" "firewall-concourse" {
  name    = "${var.env_id}-concourse-open"
  network = "${google_compute_network.bbl-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "2222" ,"8443"]
  }

  target_tags = ["concourse"]
}

resource "google_compute_forwarding_rule" "uaa-forwarding-rule" {
  name        = "${var.env_id}-concourse-uaa"
  target      = "${google_compute_target_pool.target-pool.self_link}"
  port_range  = "8443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.concourse-address.address}"
}

# vars needed for bucc flags (which are included via common.sh)
output "director__concourse_domain" {
  value = "${google_compute_address.concourse-address.address}"
}

output "director__target_pool" {
  value = "${google_compute_target_pool.target-pool.name}"
}
