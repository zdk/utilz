variable "cluster_name" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "ecr_repo" {}

variable "app_version" {
  default = "latest"
}

variable "subnets" {
  type = "list"
}

variable "autoscale_min_size" {
  default = 2
}

variable "autoscale_max_size" {
  default = 4
}

variable "autoscale_desired_size" {
  default = 3
}

variable "vpc_id" {}

variable "http_enabled" {
  default = true
}

variable "http_port" {
  default = 80
}

variable "security_group_ids" {
  type    = "list"
  default = []
}

variable "container_name" {}
variable "container_port" {}

variable "db_host" {}
variable "db_username" {}
variable "db_password" {}
variable "secret_key_base" {}
variable "redis_url" {}
variable "elasticsearch_url" {}
variable "rack_timeout_wait_timeout" {}
variable "rack_timeout_service_timeout" {}
variable "statement_timeout" {}
