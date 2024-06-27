provider "google" {
  credentials = "${file("${var.gcp_project1_credentials_file_path}")}"
  project     = "${var.gcp_project1}"
  region      = "${var.gcp_project1_region}"
  alias       = "${var.gcp_project1_provider_alias}"
}

provider "google" {
  credentials = "${file("${var.gcp_project2_credentials_file_path}")}"
  project     = "${var.gcp_project2}"
  region      = "${var.gcp_project2_region}"
  alias       = "${var.gcp_project2_provider_alias}"
}

