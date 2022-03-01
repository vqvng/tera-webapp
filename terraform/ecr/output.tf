output "aws_region" {
  value       = var.aws_region
  description = "The AWS region used"
}

output "publisher_access_key" {
  value       = aws_iam_access_key.ecr_deploy.id
  description = "AWS_ACCESS_KEY for github to push to ECR"
}

output "publisher_secret_key" {
  value       = aws_iam_access_key.ecr_deploy.secret
  description = "AWS_SECRET_ACCESS_KEY for github to push to ECR"
  sensitive   = true
}

output "ecr_repository_name" {
  value       = aws_ecr_repository.registry.name
  description = "The ECR repository name"
}
