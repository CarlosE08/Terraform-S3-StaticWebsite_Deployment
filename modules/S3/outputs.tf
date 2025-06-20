output "bucket_name" {
  value = local.bucket_name
}

output "bucket_arn" {
  value = local.bucket_arn
}

output "bucket_id" {
  value = local.bucket_id
}

output "website_url" {
  value = "http://${local.bucket_name}.s3-website-${var.region}.amazonaws.com" # Puede cambiar el estándar a https si se configura un CDN o certificado SSL, o si lo cambia AWS mismo.
  
}