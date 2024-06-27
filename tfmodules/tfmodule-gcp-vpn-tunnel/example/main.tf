module "vpn-gateway" {
  source = "../"

  gcp_project1_credentials_file_path = "${var.gcp_project1_credentials_file_path}"
  gcp_project1 = "${var.gcp_project1}"
  gcp_project1_region = "${var.gcp_project1_region}"
  gcp_project1_provider_alias = "${var.gcp_project1_provider_alias}"
  project1_network_name = "${var.project1_network_name}"

  gcp_project2_credentials_file_path = "${var.gcp_project2_credentials_file_path}"
  gcp_project2 = "${var.gcp_project2}"
  gcp_project2_region = "${var.gcp_project2_region}"
  gcp_project2_provider_alias = "${var.gcp_project2_provider_alias}"
  project2_network_name = "${var.project2_network_name}"

  enable_secondry_tunnel = "true"
  create_cgnat = "true"
  gana_endpoint = "localhost:4567"
}
