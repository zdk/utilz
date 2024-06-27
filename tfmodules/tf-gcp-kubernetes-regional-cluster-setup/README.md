# Create Regional Kubernetes cluster in GCP

- [regional kube cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-zone-and-regional-clusters#regional)

Creates a Google Kubernetes Engine (GKE) cluster with node pool.

### Arguments Required:

**gcp_credentials_file_path** (Required) - GCP service account credentials path

**gcp_project** (Required) - GCP project name

**gcp_region** (Required) - GCP region

**kubernetes_cluster_name** (Required) - The name of the cluster, unique within the project and region.

**kubernetes_initial_node_count** (Required) - The number of nodes to create in this cluster (not including the Kubernetes master)

**kubernetes_cluster_region** (Require) - The region where kube cluster need to be created

**kubernetes_node_disk_size_in_gb**(Optional) - Size of the disk attached to each node, specified in GB. Defaults to 200GB.).

**kubernetes_node_machine_type** (Optional) - The name of a Google Compute Engine machine type. Defaults to n1-standard-1

**kubernetes_minimun_autoscaling_node_count** (Optional) - Minimum number of nodes in the NodePool. Defaults is 1.

**kubernetes_maximum_autoscaling_node_count** (Optional) - Maximum number of nodes in the NodePool. Default is 4.

**aws_shared_credentials_file** (Required) - AWS credentials path. EG : ~/.aws/credentials

**gcp_network** (Optional) - Specify the network name. By default is default

\*\*gcp_subnetwork" (Optional) - Specify the subnetwork name. By default is default
####Module Usage Example:

```

module "foobar-cluster-creation" {
  source = "module remote path"

  gcp_credentials_file_path = "${var.gcp_credentials_file_path}"
  gcp_project = "${var.gcp_project}"
  gcp_region = "${var.gcp_region}"
  kubernetes_cluster_name = "${var.kubernetes_cluster_name}"
  kubernetes_initial_node_count = "${var.kubernetes_initial_node_count}"
  kubernetes_cluster_region = "${var.kubernetes_cluster_region}"
  aws_shared_credentials_file = "${var.aws_shared_credentials_file}"
}

```
