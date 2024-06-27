variable "name" {
  default = "dev-es"
}

variable "es_version" {
  default = "6.3"
}

variable "instance_type" {
  default = "t2.small"
}

variable "volume_size" {
  default = "10"
}

variable "subnet_ids" {
  type = "list"
}
