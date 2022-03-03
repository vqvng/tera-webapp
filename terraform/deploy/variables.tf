variable "aws_region" {
	type        = string
	default     = "us-west-2"
	description = "AWS Region"
}

variable "vpc_cidr" {
	type        = string
	default     = "10.0.0.0/16"
	description = "CIDR Block for VPC"
}

variable "public_subnet_cidr" {
	type        = string
	default     = "10.0.0.0/24"
	description = "CIDR Block for Public Subnet"
}

variable "public_subnet_az" {
	type        = string
	default     = "us-west-2a"
	description = "Availability Zone for Public Subnet"
}

variable "instances" {
	type = map
	default = {
		windows-instance = {
			ami = "ami-01977bc15980f9223"
			instance_type = "t2.micro"
		},

		ubuntu2004-instance = {
			ami = "ami-0892d3c7ee96c0bf7"
			instance_type = "t2.micro"
		},

		ubuntu1804-instance = {
			ami = "ami-074251216af698218"
			instance_type = "t2.micro"
		},

		rhel-instance = {
			ami = "ami-0b28dfc7adc325ef4"
			instance_type = "t2.micro"
		}
	}
}
