terraform {
  backend "gcs" {
    bucket  = "gump-tf"
    prefix  = "vpn-tunnel/system-automation-test-instance"
  }
}
