variable "s3_bucket_name" {}
variable "s3_bucket_website_domain" {}
variable "s3_bucket_hosted_zone_id" {}

resource "aws_route53_zone" "main" {
  name = "${var.s3_bucket_name}"
  tags {
    Environment = "dev"
  }
}

resource "aws_route53_record" "default" {
	zone_id = "${aws_route53_zone.main.zone_id}"
	name    = "${var.s3_bucket_name}"
	type    = "A"

	alias {
		name = "${var.s3_bucket_website_domain}"
		zone_id = "${var.s3_bucket_hosted_zone_id}"
		evaluate_target_health = true
	}
}
