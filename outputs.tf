output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = module.aws_s3.bucket_name # Accede al output del módulo aws_s3
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = module.aws_s3.bucket_arn # Accede al output del módulo aws_s3
}

output "bucket_id" {
  description = "ID del bucket S3"
  value       = module.aws_s3.bucket_id # Accede al output del módulo aws_s3
}

output "s3_bucket_website_endpoint" {
  description = "sitio web estático en S3"
  value       = module.aws_s3.bucket_website_endpoint # Accede al output del módulo aws_s3
}