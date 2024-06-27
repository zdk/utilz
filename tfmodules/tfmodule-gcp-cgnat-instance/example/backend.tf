terraform {
  backend "gcs" {
    bucket  = "gump-tf"
    prefix  = "cgnat/system-automation-test-instance"
  }
}
