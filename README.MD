# Static Website Deployment on AWS S3 with Terraform & GitHub Actions

Este proyecto despliega un sitio web estático en un bucket de Amazon S3 utilizando Terraform para definir la infraestructura y GitHub Actions para automatizar el despliegue de archivos estáticos desde la carpeta `/files`.

---

## Arquitectura

- **Amazon S3**: Bucket nuevo o existente configurado como sitio web.
- **Configuración de hosting**: Usa `index.html` como documento raíz.
- **Política pública opcional**: Habilita acceso anónimo mediante `apply_bucket_policy`.
- **GitHub Actions**: Automatiza el despliegue a S3 al hacer push a `main`.

---

## Estructura del Proyecto

```
.
├── modules/
│   └── S3/
│       ├── aws_s3.tf
│       ├── Variables.tf
│       └── outputs.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
├── terraform_sync.yml         # Despliegue de infraestructura
└── s3_deploy.yml           # Sincronización de archivos estáticos
```

---

## ⚙️ Variables Principales (`terraform.tfvars`)

```hcl
bucket_name         = "mi-sitio-estatico"
use_existing_bucket = false
apply_bucket_policy = true

common_tags = {
  owner      = "Carlos Escobar"
  customer   = "Test"
  project    = "Terraform_testing"
}
```

---

## ▶️ Instrucciones de Uso

### 1. Inicializa Terraform

```bash
terraform init
```

### 2. Aplica los cambios

```bash
terraform apply -var-file="terraform.tfvars" -auto-approve
```

### 3. Accede al sitio web

Después del `apply`, visita el sitio con:

```
http://<bucket-name>.s3-website-<region>.amazonaws.com
```

> La URL también se exporta como `output`.

---

## 🤖 Automatización con GitHub Actions

### Despliegue de Terraform (`terraform_sync.yml`)

Se ejecuta en cada push a `main` y crea/modifica la infraestructura en AWS.

### Sincronización de archivos (`deploy_to_s3.yml`)

```yaml
on:
  workflow_run:
    workflows: ["Terraform AWS Modular"]
    types:
      - completed

jobs:
  deploy:
    if: >
      github.event.workflow_run.conclusion == 'success' &&
      github.event.workflow_run.head_branch == 'main'
```

Este flujo sube automáticamente los contenidos de la carpeta `/files` a S3 si el despliegue Terraform fue exitoso en la rama `main`.

---

## 🔐 Permisos necesarios (IAM)

El usuario o rol que ejecuta Terraform debe tener permisos para:

- `s3:CreateBucket`
- `s3:PutBucketPolicy`
- `s3:PutBucketWebsite`
- `s3:PutObject`
- `s3:GetObject`
- `s3:PutBucketPublicAccessBlock`

---

## ⚠️ Consideraciones

- Asegúrate de desactivar los bloqueos de acceso público si vas a aplicar una política pública (`apply_bucket_policy = true`).
- En producción, es recomendable usar CloudFront para control de acceso y rendimiento.

---

## 📤 Outputs

```hcl
output "bucket_id"   = ...
output "bucket_arn"  = ...
output "bucket_name" = ...
output "website_url" = "http://${var.bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
```

---

## 👤 Autor

**Carlos Escobar**  
📧 carlosescobar08@proton.me
