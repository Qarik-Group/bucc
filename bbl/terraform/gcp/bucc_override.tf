# open port 8443 for uaa authentication
output "director__tags" {
  value = [
    "${google_compute_firewall.bosh-director.name}",
    "${var.env_id}-concourse-open",
    "concourse",
  ]
}

# vars needed for bucc flags (which are included via common.sh)
output "director__concourse_domain" {
  value = "${google_compute_address.concourse-address.address}"
}

output "director__target_pool" {
  value = "${google_compute_target_pool.target-pool.name}"
}

# add vault port for jumpbox
resource "google_compute_firewall" "bosh-open" {
  name    = "${var.env_id}-bosh-open"
  network = "${google_compute_network.bbl-network.name}"

  source_tags = ["${var.env_id}-bosh-open"]

  allow {
    ports    = ["22", "6868", "8443", "8844", "25555", "8200"]
    protocol = "tcp"
  }

  target_tags = ["${var.env_id}-bosh-director"]
}
