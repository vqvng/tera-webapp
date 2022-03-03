data "aws_iam_policy_document" "ecs_iam" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_iam" {
  name               = "ecs-iam"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_iam.json}"
}


resource "aws_iam_role_policy_attachment" "ecs_iam" {
  role       = "${aws_iam_role.ecs_iam.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

}

resource "aws_iam_instance_profile" "ecs_iam" {
  name = "ecs-iam"
  role = "${aws_iam_role.ecs_iam.name}"
}