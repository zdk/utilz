module "vpn-gateway" {
  source = "../"

  gcp_credentials_file_path = "${var.gcp_credentials_file_path}"
  gcp_project = "${var.gcp_project}"
  gcp_project_region = "${var.gcp_project_region}"
  network_name = "${var.network_name}"
}
