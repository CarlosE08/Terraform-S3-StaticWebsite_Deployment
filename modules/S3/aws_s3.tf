locals {
  bucket_id   = var.use_existing_bucket ? data.aws_s3_bucket.existing[0].id : aws_s3_bucket.website[0].id
  bucket_arn  = var.use_existing_bucket ? data.aws_s3_bucket.existing[0].arn : aws_s3_bucket.website[0].arn
  bucket_name = var.bucket_name
}

###############################################################################
# 2. Bucket S3 para hosting estático                                          #
###############################################################################
# Reutiliza bucket si ya existe
data "aws_s3_bucket" "existing" {
  count  = var.use_existing_bucket ? 1 : 0
  bucket = var.bucket_name
}

# Crea bucket si no existe
resource "aws_s3_bucket" "website" {
  count         = var.use_existing_bucket ? 0 : 1
  bucket        = var.bucket_name
  force_destroy = true

  tags = merge(var.common_tags, {
    environment = "${terraform.workspace}"
  })
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = local.bucket_id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = local.bucket_id

  index_document {
    suffix = "index.html"
  }

  depends_on = [
  aws_s3_bucket.website
  ]
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    sid    = "AllowPublicRead"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_policy.json

  depends_on = [
  aws_s3_bucket.website
  ]
}