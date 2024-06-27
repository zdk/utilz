variable "gcp_credentials_file_path" {}
variable "gcp_project" {}
variable "gcp_project_region" {}
variable "network_name" {}
variable "enable_secondry_gateway" {
  default = "false"
  type = "string"
}

variable "enabled" {
  default = "true"
  type = "string"
}

