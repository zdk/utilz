variable "website" {
	type = "string"
	default = "<domain>"
}

module "s3_website" {
	source    = "../modules/tfmodule-aws-s3-website"
	hostname  = "${var.website}"
}

module "hosted_zone" {
	source    = "../modules/tfmodule-aws-route53-hosted-zone"
	domain    = "${var.website}"
}

module "alias" {
	source = "../modules/tfmodule-aws-route53-alias"
	route53_hosted_zone_id   = "${module.hosted_zone.route53_hosted_zone_id}"
	s3_bucket_name           = "${var.website}"
	s3_bucket_website_domain = "${module.s3_website.s3_bucket_website_domain}"
	s3_bucket_hosted_zone_id = "${module.s3_website.s3_bucket_hosted_zone_id}"
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
		command = "./deploy.sh"
  }
}
