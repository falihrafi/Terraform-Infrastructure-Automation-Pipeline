## Required Vars
variable "custom_tags" {
  type = object({
    Environment    = string
    TargetAccounts = string
    DeploymentType = string
  })
}

variable "account_type" {
  description = "Human readable name of the targets accounts"
  type        = string
}

variable "pipeline_deployment_bucket_name" {
  description = "Bucket used by codepipeline and codebuild to store artifacts regarding the deployment"
  type        = string
}

variable "git_repository_name" {
  description = "Name of the remote source repository"
  type        = string
}

## Optional Variables
variable "account_id" {
  description = "Account ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region where the resources will be deployed"
  default     = ""
}

variable "cb_priviledged_mode" {
  description = "Enable codebuild to use docker to build images"
  type        = string
  default     = "true"
}

variable "branch" {
  description = "Branch to be built"
  type        = string
  default     = "main"
}

variable "code_pipeline_build_stages" {
  description = "maps of build type stages configured in CodePipeline"
  default = {
    "build"  = "./build/buildspec.yaml"
    "deploy" = "./build/buildspec2.yaml"
  }
}

variable "codebuild_node_size" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "CodeBuild image"
  type = string
  default = "aws/codebuild/standard:5.0"
}
