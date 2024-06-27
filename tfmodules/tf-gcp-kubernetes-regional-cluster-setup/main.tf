resource "google_container_node_pool" "np" {
  name       = "${var.kubernetes_cluster_name}-pool-1"
  region     = "${var.kubernetes_cluster_region}"
  initial_node_count = "${var.kubernetes_initial_node_count}"
  cluster    = "${google_container_cluster.gcp_kubernetes.name}"

  autoscaling {
    min_node_count = "${var.kubernetes_minimun_autoscaling_node_count}"
    max_node_count = "${var.kubernetes_maximum_autoscaling_node_count}"
  }
  node_config {
        oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      ]
        disk_size_gb = "${var.kubernetes_node_disk_size_in_gb}"
        machine_type = "${var.kubernetes_node_machine_type}"
    }
  provider = "google.${var.gcp_provider_alias}"

  version = "${var.kubernets_node_version}"
}

resource "gana_allocate_subnet" "gcp_kubernetes" {
  project = "${var.gcp_project}"
  category = "kubernetes"
  network_name = "${var.kubernetes_cluster_name}"
  endpoint = "${var.gana_endpoint}"
}

resource "google_container_cluster" "gcp_kubernetes" {
    name               = "${var.kubernetes_cluster_name}"
    region             = "${var.kubernetes_cluster_region}"
    cluster_ipv4_cidr  = "${gana_allocate_subnet.gcp_kubernetes.subnet}"
    network            = "${var.gcp_network}"
    subnetwork         = "${var.gcp_subnetwork}"

    lifecycle {
      ignore_changes = ["node_pool"]
    }

    node_pool = [{
    name = "default-pool"
    node_count= 0
    }]
    provider = "google.${var.gcp_provider_alias}"

    min_master_version = "${var.kubernets_min_master_version}"
    node_version       = "${var.kubernets_node_version}"
}

resource "aws_route53_record" "a" {
  zone_id = "${var.aws_route53_zone_primary}"
  name    = "${var.kubernetes_cluster_name}.${var.gcp_project}.kube.golabs.io."
  type    = "A"
  ttl     = "14400"
  records = ["${google_container_cluster.gcp_kubernetes.endpoint}"]
  provider = "aws.${var.aws_provider_alias}"
}

output "client_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.cluster_ca_certificate}"
}
