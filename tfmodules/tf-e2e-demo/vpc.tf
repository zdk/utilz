resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = "true"

    tags = "${merge(
				var.common_tags,
				map(
          "Name", "MainVPC"
				)
		)}"
}

resource "aws_subnet" "main_subnet_public_1" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"

    tags = "${merge(
				var.common_tags,
				map(
          "Name", "MainPublic1"
				)
		)}"
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = "${aws_vpc.main_vpc.id}"

    tags = "${merge(
				var.common_tags,
				map(
          "Name", "MainIGW"
				)
		)}"
}

resource "aws_route_table" "main_route_public" {
    vpc_id = "${aws_vpc.main_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main_igw.id}"
    }

    tags = "${merge(
				var.common_tags,
				map(
          "Name", "MainRoutePublic"
				)
		)}"
}

resource "aws_route_table_association" "main_route_assoc" {
    subnet_id = "${aws_subnet.main_subnet_public_1.id}"
    route_table_id = "${aws_route_table.main_route_public.id}"
}
