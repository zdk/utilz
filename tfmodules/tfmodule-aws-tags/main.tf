variable "name" {
	default = "my-project"
}

variable "environment" {
	default = "dev"
}

locals {
	common_tags = {
		NAME        = "${var.name}"
		Environment = "${var.environment}"
	}
}
