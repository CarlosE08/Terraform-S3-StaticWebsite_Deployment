terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  generate_name = "${var.common_tags.customer}-${var.common_tags.project}-${terraform.workspace}"
}

module "aws_iam" {
  source        = "./modules/IAM"
  common_tags   = var.common_tags
  generate_name = local.generate_name
  bucket_name   = module.aws_s3.bucket_name
  bucket_arn    = module.aws_s3.bucket_arn
  bucket_id     = module.aws_s3.bucket_id
}

module "aws_s3" {
  source        = "./modules/S3"
  common_tags   = var.common_tags
  generate_name = local.generate_name
  bucket_name   = var.bucket_name
}