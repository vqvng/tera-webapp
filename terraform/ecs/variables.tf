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

variable "repo_name" {
	type        = string
	default     = "tera-webapp"
	description = "ECR repository name"
}
