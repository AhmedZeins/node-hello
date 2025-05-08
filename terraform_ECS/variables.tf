variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
}
variable "repository_name" {
  description = "Docker image repo name"
  type        = string
}
variable "execution_role_name" {
  description = "ECS task execution role name"
  type        = string
  default     = "ecsTaskExecutionRole"
}
variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "node-hello-cluster"
}
variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}