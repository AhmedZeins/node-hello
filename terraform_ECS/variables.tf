variable "aws_region" {
  description = "AWS region, e.g. us-east-1"
  type        = string
  default     = "us-east-1"
}

variable "dockerhub_username" {
  description = "Your Docker Hub username"
  type        = string
}

variable "repository_name" {
  description = "Docker Hub repo name, e.g. node-hello"
  type        = string
}

variable "execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "desired_count" {
  description = "Number of desired ECS tasks"
  type        = number
  default     = 1
}