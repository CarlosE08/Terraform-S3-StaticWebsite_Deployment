###############################################################################
# 1. Locales para acceso condicional                                          #
###############################################################################
locals {
  bucket_id   = var.use_existing_bucket ? data.aws_s3_bucket.existing[0].id : aws_s3_bucket.website[0].id
  bucket_arn  = var.use_existing_bucket ? data.aws_s3_bucket.existing[0].arn : aws_s3_bucket.website[0].arn
  bucket_name = var.bucket_name
}

################################################################################
# Variables de entrada para el módulo S3
################################################################################
variable "apply_bucket_policy" {
  type    = bool
  default = true
  description = "Si es true, aplica una política pública de lectura al bucket S3"
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

###############################################################################
# 3. Configuración de acceso público                                          #
###############################################################################

resource "aws_s3_bucket_public_access_block" "public_access" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = local.bucket_id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

###############################################################################
# 4. Configuración como sitio web estático                                    #
###############################################################################

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = local.bucket_id

  index_document {
    suffix = "index.html"
  }

  depends_on = [
    aws_s3_bucket.website
  ]
}

###############################################################################
# 5. Política pública de lectura                                              #
###############################################################################

resource "aws_s3_bucket_policy" "public_read_policy" {
  count  = var.apply_bucket_policy ? 1 : 0
  bucket = local.bucket_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${local.bucket_name}/*"
      }
    ]
  })
}

