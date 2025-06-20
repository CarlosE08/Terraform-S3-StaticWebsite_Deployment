
# Política que permite lectura pública de los objetos dentro del bucket
# resource "aws_s3_bucket_policy" "website_policy" {
#   bucket = var.bucket_id
#   policy = data.aws_iam_policy_document.website_policy.json
# }

# data "aws_iam_policy_document" "website_policy" {
#   statement {
#     sid = "AllowPublicRead"

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     actions = ["s3:GetObject"]

#     resources = [
#       "${var.bucket_arn}/*"
#     ]
#   }
# }