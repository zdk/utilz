data "google_compute_network" "network" {
  name = "${var.network_name}"
  project = "${var.gcp_project}"
}

locals {
  gateways = ["primary", "secondary"]
  gateway_count = "${var.enable_secondry_gateway == "true" ? 2 : 1}"
  count = "${var.enabled == "true" ? local.gateway_count : 0}"
}

resource "google_compute_vpn_gateway" "vpn_gateway" {
  count = "${local.count}"
  name    = "vpn-gateway-${local.gateways[count.index]}"
  network = "${data.google_compute_network.network.self_link}"
}

resource "google_compute_address" "vpn_gateway_static_ip" {
  count = "${local.count}"
  name   = "vpn-gateway-${local.gateways[count.index]}-public-ip"
}

output "vpn_gateway_static_ips" {
  value = "${google_compute_address.vpn_gateway_static_ip.*.address}"
}

output "vpn_gateway_selflinks" {
  value = "${google_compute_vpn_gateway.vpn_gateway.*.self_link}"
}

output "vpn_gateway_names" {
  value = "${google_compute_vpn_gateway.vpn_gateway.*.name}"
}

output "vpn_gateway_public_ip_names" {
  value = "${google_compute_address.vpn_gateway_static_ip.*.name}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  count = "${local.count}"
  name        = "fr-esp-vpn-gateway-${local.gateways[count.index]}"
  ip_protocol = "ESP"
  ip_address  = "${element(google_compute_address.vpn_gateway_static_ip.*.address, count.index)}"
  target      = "${element(google_compute_vpn_gateway.vpn_gateway.*.self_link, count.index)}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  count = "${local.count}"
  name        = "fr-udp500-vpn-gateway-${local.gateways[count.index]}"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = "${element(google_compute_address.vpn_gateway_static_ip.*.address, count.index)}"
  target      = "${element(google_compute_vpn_gateway.vpn_gateway.*.self_link, count.index)}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  count = "${local.count}"
  name        = "fr-udp4500-vpn-gateway-${local.gateways[count.index]}"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = "${element(google_compute_address.vpn_gateway_static_ip.*.address, count.index)}"
  target      = "${element(google_compute_vpn_gateway.vpn_gateway.*.self_link, count.index)}"
}

