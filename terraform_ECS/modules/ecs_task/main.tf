resource "aws_ecs_task_definition" "task" {
  family                   = "${var.repository_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.repository_name
      image     = "${var.dockerhub_user}/${var.repository_name}:latest"
      essential = true
      portMappings = [{ 
        containerPort=3000
        hostPort=3000 }]
          logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.repository_name
        }
      }
    }
  ])
}