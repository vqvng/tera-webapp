resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.public_subnet_az}"
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public_rt" {
	vpc_id = "${aws_vpc.vpc.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.ig.id}"
	}
}

resource "aws_route_table_association" "public_subnet_rta" {
	subnet_id      = "${aws_subnet.public_subnet.id}"
	route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_security_group" "sg" {
	name   = "sg"
	vpc_id = "${aws_vpc.vpc.id}"

	ingress {
		description = "ssh"
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "http"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "https"
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "rdp"
		from_port   = 3389
		to_port     = 3389
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

/* 
 * Create multiple instances on AWS
 */

resource "aws_instance" "instance" {
	for_each = var.instances

	ami                    = each.value.ami
	instance_type          = each.value.instance_type
	subnet_id              = aws_subnet.public_subnet.id
	vpc_security_group_ids = ["${aws_security_group.sg.id}"]
	key_name               = "github"
}
