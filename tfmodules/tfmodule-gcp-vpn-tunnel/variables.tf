variable "gcp_project1_credentials_file_path" {}
variable "gcp_project1" {}
variable "gcp_project1_region" {}
variable "gcp_project1_provider_alias" {}
variable "project1_network_name" {}

variable "gcp_project2_credentials_file_path" {}
variable "gcp_project2" {}
variable "gcp_project2_region" {}
variable "gcp_project2_provider_alias" {}
variable "project2_network_name" {}

variable "enable_secondry_tunnel" {
  default = "false"
  type = "string"
  description = "Supported values: true/false"
}

variable "create_cgnat" {
  default = "false"
  type = "string"
  description = "Supported values: true/false"
}

variable "cgnat_priority" {
  default = "800,850"
  type = "string"
}

variable "normal_priority" {
  default = "900,950"
  type = "string"
}

variable "gana_endpoint" {
  default = "integration.external.zdklabs.io"
}

variable "depends_on" {
  default = []
  type = "list"
}

variable "project1_vpn_gateway_names" {
  default = ["vpn-gateway-primary","vpn-gateway-secondary"]
}

variable "project1_vpn_gateway_public_ip_names" {
  default = ["vpn-gateway-primary-public-ip","vpn-gateway-secondary-public-ip"]
}

variable "project2_vpn_gateway_names" {
  default = ["vpn-gateway-primary","vpn-gateway-secondary"]
}

variable "project2_vpn_gateway_public_ip_names" {
  default = ["vpn-gateway-primary-public-ip","vpn-gateway-secondary-public-ip"]
}

