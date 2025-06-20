output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.website.bucket
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.website.arn
}

output "bucket_website_endpoint" {
  description = "Endpoint del sitio web estático en S3"
  value       = aws_s3_bucket.website.website_endpoint
}

output "bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket.website.id
}