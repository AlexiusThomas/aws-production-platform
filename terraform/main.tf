data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

moved {
  from = module.vpc
  to   = module.networking
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.10.0/24",
    "10.0.20.0/24"
  ]
}