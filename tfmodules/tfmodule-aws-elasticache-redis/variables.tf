variable "name" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "subnet_ids" {
  type = "list"
}

variable "instance_type" {
  default = "t2.small"
}

variable "engine_version" {
  default = "5.0.0"
}

variable "redis_port" {
  default = 6379
}

variable "parameter_group_name" {
  default = "default.redis5.0"
}
