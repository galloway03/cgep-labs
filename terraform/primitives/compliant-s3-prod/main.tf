# terraform/primitives/compliant-s3-prod/main.tf
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

provider "aws" {
  region = "us-east-1"
}

output "attestation" { value = module.data_bucket.compliance_attestation }
output "bucket_url"  { value = module.data_bucket.bucket_url }
output "bucket_name" { value = module.data_bucket.bucket_name }

module "data_bucket" {
  source = "../../modules/compliant-s3"

  #project        = var.project_name
  project_name      = "cgep-lab-prod"
  environment        = "prod"
  retention_days     = 365
  bucket_suffix = "prod-s3galloway-001"   # use your personal suffix, e.g. prod-data-<your-initials>
}