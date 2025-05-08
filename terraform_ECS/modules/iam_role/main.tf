data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions    = ["sts:AssumeRole"]
    principals { 
    type = "Service"
    identifiers = ["ecs-tasks.amazonaws.com"]
     }
  }
}
resource "aws_iam_role" "ecs_exec" {
  name               = var.execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}
resource "aws_iam_role_policy_attachment" "exec_policy" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}