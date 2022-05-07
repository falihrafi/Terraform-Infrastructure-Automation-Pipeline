resource "aws_codecommit_repository" "code_repo" {
  repository_name = var.git_repository_name
  description     = "Code Repository"

  tags = var.custom_tags
}
