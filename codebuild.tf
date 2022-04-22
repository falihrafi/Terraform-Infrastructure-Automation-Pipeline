resource "aws_codebuild_project" "codebuild_deployment" {
  name          = "${var.git_repository_name}-build"
  description   = "Code build project for ${var.git_repository_name} build stage"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.cb_priviledged_mode
    compute_type                = var.codebuild_node_size
  }

  logs_config {
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.id}/build/build_logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.code_pipeline_build_stages["build"]
  }

  tags = var.custom_tags
}

