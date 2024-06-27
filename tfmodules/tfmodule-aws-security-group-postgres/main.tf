variable "vpc_id" {}

resource "aws_security_group" "allow_postgres" {
  name        = "allow-postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "allow_postgres"
  }
}

resource "aws_security_group_rule" "rds-allow-ingress-postgres" {
  type        = "ingress"
  from_port   = 0
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]

  security_group_id = "${aws_security_group.allow_postgres.id}"
}
