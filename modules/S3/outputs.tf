output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.website.bucket
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.website.arn
}

output "bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket.website.id
}