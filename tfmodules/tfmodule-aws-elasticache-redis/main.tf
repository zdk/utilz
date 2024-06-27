resource "aws_security_group" "redis" {
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.name}"
  description = "${var.name} subnet group"
  subnet_ids  = ["${var.subnet_ids}"]
}

resource "aws_elasticache_cluster" "redis" {
  engine               = "redis"
  engine_version       = "${var.engine_version}"
  cluster_id           = "${var.name}"
  node_type            = "cache.${var.instance_type}"
  port                 = "${var.redis_port}"
  num_cache_nodes      = "1"
  subnet_group_name    = "${aws_elasticache_subnet_group.redis.name}"
  security_group_ids   = ["${aws_security_group.redis.id}"]
  parameter_group_name = "${var.parameter_group_name}"
}
