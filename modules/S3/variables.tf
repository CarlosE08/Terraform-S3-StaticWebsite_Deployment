variable "common_tags" {}
variable "generate_name" {}
#variable region { }
variable "bucket_name" {}

variable "use_existing_bucket" {
  description = "Si es true, reutiliza un bucket S3 existente en lugar de crearlo"
  type        = bool
  default     = false
}