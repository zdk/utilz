terraform {
  backend "gcs" {
    bucket  = "gump-tf"
    prefix  = "vpn-gateway/system-automation-test-instance"
  }
}
