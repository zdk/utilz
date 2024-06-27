output "web_instance" {
  value = "${aws_instance.web.public_ip}"
}
