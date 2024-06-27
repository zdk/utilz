terraform {
  backend "gcs" {
    bucket  = "gump-tf"
    prefix  = "vpn-gateway/systems-0001"
  }
}
