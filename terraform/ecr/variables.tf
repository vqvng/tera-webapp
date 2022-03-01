variable "aws_region" {
	type        = string
	default     = "us-west-2"
	description = "AWS region"
}

variable "repo_name" {
	type        = string
	default     = "tera-webapp"
	description = "ECR repository name"
}