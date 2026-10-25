terraform {
  required_version = ">= 1.6"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4

}
locals {
  effective_suffix = var.bucket_suffix != "" ? var.bucket_suffix : random_id.bucket_suffix.hex

  required_tags = {
    Project         = var.project_name
    Environment     = var.environment
    ManagedBy       = "terraform"
    ComplianceScope = "cge-p-lab"
    retention_days = 30

  }

  effective_tags = merge(var.tags, local.required_tags)
  bucket_name    = "${var.project_name}-${var.environment}-${local.effective_suffix}"
}

# SC-12: cryptographic key establishment. We own the key, not AWS.
# AWS has no keyring, so the key is the only resource needed.
# SC-13 / SC-28: cryptographic protection at rest. 90-day rotation.
resource "aws_kms_key" "key" {
  description             = "CMEK for ${local.bucket_name}"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7 # minimum; keys can't be deleted immediately

  tags = local.effective_tags

  lifecycle {
    prevent_destroy = false # set true in production
  }
}

# The GCP IAM binding for the storage service account has no equivalent.
# S3 uses the caller's permissions, and the default key policy covers
# your admin identity.

# AC-3 + SC-28 + CM-6 + AU-11 are split across resources on AWS.
resource "aws_s3_bucket" "bucket" {
  bucket              = local.bucket_name
  object_lock_enabled = true # must be set at creation (AU-11)

  tags = local.effective_tags # CM-6
}

# AC-3: uniform access (ACLs disabled)
resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# AC-3: public access prevention (all four flags)
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CM-6: versioning (also required by Object Lock)
resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SC-28: encrypt with the key above
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.key.arn
    }
    bucket_key_enabled = true
  }
}

# AU-11: retention. GOVERNANCE mode matches the lab's is_locked = false.
resource "aws_s3_bucket_object_lock_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = var.retention_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.bucket]
}