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

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                = module.networking.vpc_id
  alb_security_group_id = module.networking.alb_security_group_id
  public_subnet_ids     = module.networking.public_subnet_ids
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "ecs_service" {
  source = "./modules/ecs-service"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  ecs_cluster_id = module.ecs.cluster_id

  image_uri = "${module.ecr.repository_url}:latest"

  private_subnet_ids    = module.networking.private_subnet_ids
  ecs_security_group_id = module.networking.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
}

module "github_oidc" {
  source = "./modules/github-oidc"

  github_owner      = "AlexiusThomas"
  github_repository = "aws-production-platform"
  project_name      = var.project_name
  environment       = var.environment
}