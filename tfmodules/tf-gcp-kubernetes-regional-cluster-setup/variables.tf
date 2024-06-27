variable "gcp_credentials_file_path" {}
variable "gcp_project" {}
variable "gcp_region" {}
variable "gcp_provider_alias" {
    default = "gcp"
    }
variable "kubernetes_cluster_name" {}
variable "kubernetes_initial_node_count" {}
variable "kubernetes_cluster_region" {}
variable "kubernetes_node_disk_size_in_gb" {
    default = "200"
    }
variable "kubernetes_node_machine_type" {
    default = "n1-standard-1"
    }
variable "kubernetes_minimun_autoscaling_node_count" {
   default = "1"
   }
variable "kubernetes_maximum_autoscaling_node_count" {
   default = "4"
   }
variable "aws_route53_zone_primary" {
    default = "Z24YPR5CTF6DRD"
}
variable "aws_region" {
    default = "ap-southeast-1"
}
variable "aws_provider_alias" {
    default = "aws"
}
variable "aws_shared_credentials_file" {}

variable "gcp_network" {
  default = "default"
}

variable "gcp_subnetwork" {
}

variable "kubernets_min_master_version" {
  default = "1.10.2-gke.3"
}

variable "kubernets_node_version" {
  default = "1.10.2-gke.3"
}

variable "gana_endpoint" {
  default = "integration.gana.golabs.io"
}

