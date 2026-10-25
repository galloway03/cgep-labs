# terraform/primitives/compliant-gcs-negative/main.tf  (module block; also include provider + outputs from Step 4)

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

  project_name      = "cgep-lab-prod"
  environment        = "prod"
  retention_days     = 30 # FAILS: prod requires >= 365
  bucket_suffix = "should-never-exist"   
}