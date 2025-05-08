variable "cluster_id"          { type = string }
variable "task_definition_arn" { type = string }
variable "subnet_ids"          { type = list(string) }
variable "security_group_ids"  { type = list(string) }
variable "desired_count"       { type = number }
variable "repository_name"     { type  = string }