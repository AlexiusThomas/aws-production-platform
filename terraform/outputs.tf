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
