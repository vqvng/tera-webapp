resource "aws_ecs_cluster" "ecs_cluster" {
	name = "ecs_cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
	family = "service"

	container_definitions = jsonencode([
		{
			name         = "webapp"
			image        = "576614486407.dkr.ecr.us-west-2.amazonaws.com/tera-webapp:latest"
			cpu          = 10
			memory       = 512
			essential    = true
			portMappings = [
				{
					containerPort = 80
					hostPort      = 80
				}
			]
		},
		{
			name         = "redis"
			image        = "redis-alpine:latest"
			cpu          = 10
			memory       = 512
			essential    = true
			portMappings = [
				{
					containerPort = 6379
					hostPort      = 6379
				}
			]
		}
	])
}

resource "aws_ecs_service" "ecs_service" {
	name            = "ecs_service"
	cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
	task_definition = "${aws_ecs_task_definition.task_definition.arn}"
	desired_count    = 1
}

resource "aws_instance" "ecs_instance" {
	ami                    = "ami-0ca05c6eaa4ac40e0"
	instance_type          = "t2.micro"
	iam_instance_profile   = "${aws_iam_instance_profile.ecs_iam.name}"
	subnet_id              = "${aws_subnet.public_subnet.id}"
	vpc_security_group_ids = ["${aws_security_group.sg.id}"]
	key_name               = "helloworld"
	associate_public_ip_address = true
	user_data              = <<-EOF
		#!/bin/bash
		yum update -y
		amazon-linux-extras disable docker
		amazon-linux-extras install -y ecs
		systemctl enable --now ecs
		echo ECS_CLUSTER=ecs_cluster >> /etc/ecs/ecs.config
	EOF
}
