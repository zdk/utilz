module "cgnat-instance" {
  source = "../"

  gcp_credentials_file_path = "${var.gcp_credentials_file_path}"
  gcp_project = "${var.gcp_project}"
  gcp_project_region = "${var.gcp_project_region}"
  gcp_project_zone = "${var.gcp_project_zone}"
  network_name = "${var.network_name}"
  subnet_name = "${var.subnet_name}"
}
