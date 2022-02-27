resource "aws_iam_user" "ecr_deploy" {
  name = "ecr-deploy"
  path = "/serviceaccounts/"
}

resource "aws_iam_user_policy" "ecr_deploy" {
  name = "ecr-deploy"
  user = aws_iam_user.ecr_deploy.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:PassRole",
        "iam:GetRole",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "ecr_deploy" {
  user = aws_iam_user.ecr_deploy.name
}
