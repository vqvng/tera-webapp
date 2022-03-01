/*
 * AWS IAM user and policy
 */

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

/*
 * AWS ECR
 */

resource "aws_ecr_repository" "registry" {
	name = local.ecr_repository_name
	image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "policy" {
	repository = aws_ecr_repository.registry.name

  	policy = <<EOF
	{
    	"Version": "2008-10-17",
    	"Statement": [
        	{
            	"Sid": "new policy for ${local.ecr_repository_name}",
            	"Effect": "Allow",
            	"Principal": "*",
            	"Action": [
                	"ecr:GetDownloadUrlForLayer",
                	"ecr:BatchGetImage",
                	"ecr:BatchCheckLayerAvailability",
                	"ecr:PutImage",
	                "ecr:InitiateLayerUpload",
	                "ecr:UploadLayerPart",
	                "ecr:CompleteLayerUpload",
	                "ecr:DescribeRepositories",
	                "ecr:GetRepositoryPolicy",
	                "ecr:ListImages",
	                "ecr:DeleteRepository",
	                "ecr:BatchDeleteImage",
	                "ecr:SetRepositoryPolicy",
	                "ecr:DeleteRepositoryPolicy"
            	]
        	}
    	]
	}
	EOF
}