output "route53_hosted_zone_id" {
	value = "${aws_route53_zone.default.zone_id}"
}
