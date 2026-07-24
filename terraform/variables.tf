variable "aws_region" {
  description = "AWS region used for the infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used to identify project resources."
  type        = string
  default     = "aws-production-platform"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}