output "aws_account_id" {
  description = "AWS account currently authenticated with Terraform."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region currently configured for Terraform."
  value       = data.aws_region.current.region
}