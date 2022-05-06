resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "${var.pipeline_deployment_bucket_name}-codebuild"
  tags = var.custom_tags
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.pipeline_deployment_bucket_name}-codepipeline"
  tags = var.custom_tags
}

resource "aws_s3_bucket_acl" "pipeline_buckets" {
  for_each = local.buckets_to_lock
  bucket = each.value
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "pipeline_buckets" {
  for_each = local.buckets_to_lock
  bucket = each.value
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline_buckets" {
  for_each                = local.buckets_to_lock
  bucket                  = each.value
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
