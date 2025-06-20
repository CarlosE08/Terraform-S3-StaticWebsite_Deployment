# Variables definition
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

variable "bucket_name" {}

variable "common_tags" {
  description = "Etiquetas comunes para todos los recursos"
  type = object({
    owner    = string
    customer = string
    project  = string
  })
  default = {
    owner    = "Carlos Escobar"
    customer = "Test"
    project  = "Terraform_testing"
  }
}