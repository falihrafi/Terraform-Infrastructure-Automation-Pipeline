resource "aws_codecommit_repository" "code_repo" {
  repository_name = var.git_repository_name
  description     = "Code Repository"

  tags = var.custom_tags
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.git_repository_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source-${var.git_repository_name}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.git_repository_name
        BranchName     = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build-${aws_codebuild_project.codebuild_deployment.name}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_deployment.name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = var.branch
          },
          {
            name  = "PROJECT_NAME"
            value = var.account_type
        }])
      }
    }
  }
  tags = var.custom_tags
}
