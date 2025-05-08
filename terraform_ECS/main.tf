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

# 1. Networking: Default VPC & Subnets + Security Group
module "network" {
  source = "./modules/network"
}
# 2. Logging: CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.repository_name}"
  retention_in_days = 7
}

# 3. IAM Role: ECS Task Execution Role
data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_exec" {
  name               = var.execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_logs" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 4. ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.repository_name}-cluster"
}

# 5. ECS Task Definition for Fargate
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.repository_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_exec.arn

  container_definitions = jsonencode([
    {
      name      = var.repository_name
      image     = "${var.dockerhub_username}/${var.repository_name}:latest"
      essential = true
      portMappings = [
        { containerPort = 3000, hostPort = 3000 }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.repository_name
        }
      }
    }
  ])
}

# 6. ECS Service
resource "aws_ecs_service" "service" {
  name            = "${var.repository_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.network.subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}