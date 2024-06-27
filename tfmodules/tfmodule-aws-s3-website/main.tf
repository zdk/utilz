resource "aws_s3_bucket" "default" {
  bucket = "${var.hostname}"
  policy = "${file("${path.module}/policy.json")}"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  force_destroy = true
}
