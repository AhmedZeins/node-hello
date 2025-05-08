terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"
}

module "iam_role" {
  source              = "./modules/iam_role"
  execution_role_name = var.execution_role_name
}

module "log_group" {
  source           = "./modules/log_group"
  repository_name  = var.repository_name
  retention_in_days = var.log_retention_days
}

module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "ecs_task" {
  source             = "./modules/ecs_task"
  execution_role_arn = module.iam_role.iam_role_arn
  dockerhub_user     = var.dockerhub_username
  repository_name    = var.repository_name
  log_group_name     = module.log_group.log_group_name
  aws_region         = var.aws_region
}

module "ecs_service" {
  source              = "./modules/ecs_service"
  cluster_id          = module.ecs_cluster.cluster_id
  task_definition_arn = module.ecs_task.task_definition_arn
  subnet_ids          = module.network.subnet_ids
  security_group_ids  = [module.network.security_group_id]
  desired_count       = var.desired_count
  repository_name     = var.repository_name
}