output "aws_account_id" {
  description = "AWS Account ID."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region."
  value       = data.aws_region.current.region
}

output "vpc_id" {
  description = "ID of the application VPC."
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the application VPC."
  value       = module.networking.vpc_cidr_block
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_name" {
  value = module.ecr.repository_name
}

output "github_actions_role_arn" {
  description = "IAM role ARN used by GitHub Actions"
  value       = module.github_oidc.role_arn
}