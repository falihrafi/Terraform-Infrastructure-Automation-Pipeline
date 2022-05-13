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

  stage {
    name = "Approve"

    action {
      name     = "Approval-${var.git_repository_name}"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration {
        NotificationArn = aws_sns_topic.notification_topic.arn
        CustomData = var.approve_comment
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy-${aws_codebuild_project.codebuild_deployment_deploy.name}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["deploy_output"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_deployment_deploy.name
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
