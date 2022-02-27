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