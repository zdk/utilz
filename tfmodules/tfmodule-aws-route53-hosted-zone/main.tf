variable domain {}

resource "aws_route53_zone" "default" {
  name = "${var.domain}"

  tags {
    Environment = "dev"
  }
}
