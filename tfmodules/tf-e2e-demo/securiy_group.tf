resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
			from_port   = 22
			to_port     = 22
			protocol    = "tcp"
			cidr_blocks = ["0.0.0.0/0"] # demo: to deploy from gitlab
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

	tags = "${merge(
			var.common_tags,
			map(
				"Name", "allow_ssh"
			)
	)}"

}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow Web inbound traffic"

	ingress {
			from_port   = 80
			to_port     = 80
			protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
			from_port   = 443
			to_port     = 443
			protocol    = "tcp"
			self        = true
      cidr_blocks = ["0.0.0.0/0"]
	}

	tags = "${merge(
			var.common_tags,
			map(
				"Name", "allow_web"
			)
	)}"

}
