resource "aws_route53_zone" "kube" {
  name = "kube.<domain>"

  tags {
    Environment = "dev"
  }
}

resource "aws_route53_record" "kube-ns" {
  #zone_id = "${aws_route53_zone.main.zone_id}"
	zone_id = "Z3U0A8ZAEC1LFE"
  name    = "kube.<domain>"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.kube.name_servers.0}",
    "${aws_route53_zone.kube.name_servers.1}",
    "${aws_route53_zone.kube.name_servers.2}",
    "${aws_route53_zone.kube.name_servers.3}",
  ]
}
