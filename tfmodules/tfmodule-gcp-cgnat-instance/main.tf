resource "google_compute_address" "cgnat_static_ip" {
  name = "cgnat-static-ip"
}

output "cgnat static ip" {
  value = "${google_compute_address.cgnat_static_ip.address}"
}

resource "google_compute_instance" "cgnat-instance" {
  name         = "cgnat-01"
  machine_type = "n1-standard-2"
  zone         = "${var.gcp_project_zone}"
  can_ip_forward = "true"

  tags = ["cgnat-instance"]

  boot_disk {
    initialize_params {
      size  = "10"
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20170610"
    }
  }

  network_interface {
    subnetwork = "${var.subnet_name}"

    access_config {
      nat_ip   = "${google_compute_address.cgnat_static_ip.address}"
    }
  }
}

output "cgnat instance name" {
  value = "${google_compute_instance.cgnat-instance.name}"
}

output "cgnat instance private ip address" {
  value = "${google_compute_instance.cgnat-instance.network_interface.0.address}"
}

output "cgnat instance NAT ip address" {
  value = "${google_compute_instance.cgnat-instance.network_interface.0.access_config.0.assigned_nat_ip}"
}

resource "google_compute_route" "cgnat-all" {
  name        = "cgnat-all"
  dest_range  = "100.64.0.0/10"
  network     = "${var.network_name}"
  next_hop_instance = "${google_compute_instance.cgnat-instance.name}"
  next_hop_instance_zone = "${google_compute_instance.cgnat-instance.zone}"
  priority    = 900
}

