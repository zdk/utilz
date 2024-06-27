variable "name" {
  default = "demo-simple-vpc"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
	type = "list"
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "private_subnets" {
	type = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
	type = "list"
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_nat" {
	description = "Enable NAT Gateway for Private Subnet"
  default = true
}

variable "common_tags" {
  type = "map"
	default = {}
}

variable "tags" {
  type = "map"
	default = {}
}

variable "vpc_tags" {
  description = "VPC Tags"
  default     = {}
}

variable "igw_tags" {
  description = "Internet gateway Tags"
  default     = {}
}

variable "public_subnet_tags" {
  description = "Public subnets Tags"
  default     = {}
}

variable "private_subnet_tags" {
  description = "Private subnets Tags"
  default     = {}
}

variable "public_route_table_tags" {
  description = "Public route tables Tags"
  default     = {}
}

variable "private_route_table_tags" {
  description = "Private route tables Tags"
  default     = {}
}

variable "nat_gateway_tags" {
  description = "NAT gateway Tags"
  default     = {}
}

variable "nat_eip_tags" {
  description = "NAT EIPs Tags"
  default     = {}
}
