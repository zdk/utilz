locals {
  vpc_id            = "${aws_vpc.default.id}"
  nat_gateway_count = 1
}

# VPC
resource "aws_vpc" "default" {
  cidr_block                       = "${var.cidr}"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = false
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = "${merge(
		var.common_tags,
		var.vpc_tags
  )}"
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  count  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${local.vpc_id}"

  tags = "${merge(
	  var.common_tags,
		var.igw_tags
 )}"
}

# Publiс Route Table
resource "aws_route_table" "public" {
  count  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${local.vpc_id}"

  tags = "${merge(
					var.common_tags,
					map("Name", format("%s-public", var.name)),
					var.tags,
					var.public_route_table_tags
		     )}"
}

resource "aws_route" "public_internet_gateway" {
  count                  = "${length(var.public_subnets) > 0 ? 1 : 0}"
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.default.id}"
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  count  = 1
  vpc_id = "${local.vpc_id}"

  tags = "${merge(
						var.common_tags,
						map("Name", "${var.name}-private"),
						var.tags,
						var.private_route_table_tags
		       )}"
}

# Public Subnet
resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = "${local.vpc_id}"
  cidr_block              = "${element(concat(var.public_subnets, list("")), count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = "${merge(
					var.common_tags,
					map("Name", format("%s-public-%s", var.name, element(var.availability_zones, count.index))),
					var.tags,
					var.public_subnet_tags)
	       }"
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = "${length(var.private_subnets)}"
  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags = "${merge(
						var.common_tags,
						map("Name", format("%s-private-%s", var.name, element(var.availability_zones, count.index))),
						var.tags,
						var.private_subnet_tags
	        )}"
}

# NAT Gateway

locals {
  nat_gateway_ips = "${aws_eip.nat.*.id}"
}

resource "aws_eip" "nat" {
  count = "${ var.enable_nat ? local.nat_gateway_count : 0}"

  vpc = true

  tags = "${merge(
						var.common_tags,
            map("Name", format("%s-%s", var.name, element(var.availability_zones, 0) )),
		        var.tags,
						var.nat_eip_tags
	        )}"
}

resource "aws_nat_gateway" "default" {
  count = "${ var.enable_nat ? local.nat_gateway_count : 0}"

  allocation_id = "${element(local.nat_gateway_ips, 0)}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"

  depends_on = ["aws_internet_gateway.default"]

  tags = "${merge(
						var.common_tags,
						map("Name", format("%s-%s", var.name, element(var.availability_zones, 0))),
						var.tags,
						var.nat_gateway_tags
	        )}"
}

resource "aws_route" "private_nat_gateway" {
  count = "${ var.enable_nat ? local.nat_gateway_count : 0}"

  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id = "${element(aws_nat_gateway.default.*.id, count.index)}"

  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

# Route Table Association

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, 0)}"
}
