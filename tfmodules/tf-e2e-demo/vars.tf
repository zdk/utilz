variable "AWS_PROFILE" {
	default = "terraform-e2e-demo"
}

variable "AMIS" {
  type = "map"
  default = {
    ap-southeast-1 = "ami-51a7aa2d"
  }
}

variable "myip" {
	default = "<Fixed IP Address>"
}

variable "aws_instance_type" {
	default = "t2.micro"
}

variable "common_tags" {
	default = {
		App = "DemoBasic"
		Environment = "Prod"
		Terraform = true
	}
}
