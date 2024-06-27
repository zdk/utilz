locals {
  types = ["primary", "secondary"]
  count = "${var.enable_secondry_tunnel == "true" ? 2 : 1}"
  priority_string = "${var.create_cgnat == "true" ? var.cgnat_priority : var.normal_priority}"
  priority = "${split(",", local.priority_string)}"
}

output "count" {
  value = "${local.count}"
}

data "google_compute_vpn_gateway" "project1_gateway" {
  count = "${local.count}"
  name = "${var.project1_vpn_gateway_names[count.index]}"
  project = "${var.gcp_project1}"
  provider = "google.${var.gcp_project1_provider_alias}"
}

data "google_compute_vpn_gateway" "project2_gateway" {
  count = "${local.count}"
  name = "${var.project2_vpn_gateway_names[count.index]}"
  project = "${var.gcp_project2}"
  provider = "google.${var.gcp_project2_provider_alias}"
}

data "google_compute_address" "project1_gateway_static_ip" {
   count = "${local.count}"
   name = "${var.project1_vpn_gateway_public_ip_names[count.index]}"
   project = "${var.gcp_project1}"
   provider = "google.${var.gcp_project1_provider_alias}"
}

data "google_compute_address" "project2_gateway_static_ip" {
   count = "${local.count}"
   name = "${var.project2_vpn_gateway_public_ip_names[count.index]}"
   project = "${var.gcp_project2}"
   provider = "google.${var.gcp_project2_provider_alias}"
}

data "gana_subnet" "gcp_project1" {
    project = "${var.gcp_project1}"
    category  = "${var.create_cgnat == "true" ? "cgnat" : "vpc"}"
    network_name = "${var.project1_network_name}"
    endpoint = "${var.gana_endpoint}"
}

data "gana_subnet" "gcp_project2" {
    project = "${var.gcp_project2}"
    category  = "${var.create_cgnat == "true" ? "cgnat" : "vpc"}"
    network_name = "${var.project2_network_name}"
    endpoint = "${var.gana_endpoint}"
}

resource "random_string" "password" {
  length = 32
  special = true
}

resource "google_compute_vpn_tunnel" "project1_to_project2_tunnel" {
  count = "${local.count}"
  name          = "${var.gcp_project1_provider_alias}-to-${var.gcp_project2_provider_alias}-tunnel-${local.types[count.index]}"
  peer_ip       = "${element(data.google_compute_address.project2_gateway_static_ip.*.address, count.index)}"
  shared_secret = "${random_string.password.result}"

  target_vpn_gateway = "${element(data.google_compute_vpn_gateway.project1_gateway.*.self_link, count.index)}"
  local_traffic_selector  = ["${data.gana_subnet.gcp_project1.subnet}"]
  remote_traffic_selector = ["${data.gana_subnet.gcp_project2.subnet}"]

  lifecycle {
    ignore_changes = ["shared_secret"]
  }

  provider = "google.${var.gcp_project1_provider_alias}"
}

resource "google_compute_vpn_tunnel" "project2_to_project1_tunnel" {
  count = "${local.count}"
  name          = "${var.gcp_project2_provider_alias}-to-${var.gcp_project1_provider_alias}-tunnel-${local.types[count.index]}"
  peer_ip       = "${element(data.google_compute_address.project1_gateway_static_ip.*.address, count.index)}"
  shared_secret = "${random_string.password.result}"

  target_vpn_gateway = "${element(data.google_compute_vpn_gateway.project2_gateway.*.self_link, count.index)}"

  local_traffic_selector  = ["${data.gana_subnet.gcp_project2.subnet}"]
  remote_traffic_selector = ["${data.gana_subnet.gcp_project1.subnet}"]

  lifecycle {
    ignore_changes = ["shared_secret"]
  }

  provider = "google.${var.gcp_project2_provider_alias}"
}

resource "google_compute_route" "cgnat-tunnel-route-project1" {
  count = "${local.count}"
  name        = "cgnat-${var.gcp_project1_provider_alias}-to-${var.gcp_project2_provider_alias}-tunnel-${local.types[count.index]}"
  dest_range  = "${data.gana_subnet.gcp_project2.subnet}"
  network     = "${var.project1_network_name}"
  next_hop_vpn_tunnel = "${element(google_compute_vpn_tunnel.project1_to_project2_tunnel.*.self_link, count.index)}"
  tags = ["cgnat-instance"]
  priority    = "${local.priority[count.index]}"
  provider = "google.${var.gcp_project1_provider_alias}"
}

resource "google_compute_route" "cgnat-tunnel-route-project2" {
  count = "${local.count}"
  name        = "${var.gcp_project2_provider_alias}-to-${var.gcp_project1_provider_alias}-tunnel-${local.types[count.index]}"
  dest_range  = "${data.gana_subnet.gcp_project1.subnet}"
  network     = "${var.project2_network_name}"
  next_hop_vpn_tunnel = "${element(google_compute_vpn_tunnel.project2_to_project1_tunnel.*.self_link, count.index)}"
  tags = ["cgnat-instance"]
  priority    = "${local.priority[count.index]}"
  provider = "google.${var.gcp_project2_provider_alias}"
}
