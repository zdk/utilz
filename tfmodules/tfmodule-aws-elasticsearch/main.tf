resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.name}"
  elasticsearch_version = "${var.es_version}"

  cluster_config {
    instance_type = "${var.instance_type}.elasticsearch"
  }

  vpc_options {
    subnet_ids = "${var.subnet_ids}"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "${var.volume_size}"
    volume_type = "gp2"
  }

  tags = {
    Domain = "${var.name}"
  }
}
