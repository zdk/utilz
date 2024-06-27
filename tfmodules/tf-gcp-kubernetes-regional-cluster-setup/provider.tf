provider "google" {
  credentials = "${file("${var.gcp_credentials_file_path}")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  alias       = "${var.gcp_provider_alias}"
}

provider "aws" {
  region = "${var.aws_region}"
  shared_credentials_file = "${file("${var.aws_shared_credentials_file}")}"
  alias       = "${var.aws_provider_alias}"
}
