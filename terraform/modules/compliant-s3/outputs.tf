output "bucket_url" {
  value       = "s3://${aws_s3_bucket.bucket.id}"
  description = "s3:// URL of the compliant bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "ARN of the compliant bucket."
}

output "bucket_name" {
  value       = aws_s3_bucket.bucket.id
  description = "Name of the compliant bucket (used by verify.sh)."
}

output "kms_key_id" {
  value       = aws_kms_key.key.arn
  description = "ARN of the customer managed key protecting this bucket."
}

output "compliance_attestation" {
  description = "Computed attestation of the controls this module enforces."
  value = {
    # SC-28 / SC-13: read from the live resource, not hardcoded
    encryption_algorithm = one([
      for r in aws_s3_bucket_server_side_encryption_configuration.bucket.rule :
      r.apply_server_side_encryption_by_default[0].sse_algorithm
    ])

    # CM-6: versioning
    versioning_enabled = aws_s3_bucket_versioning.bucket.versioning_configuration[0].status == "Enabled"

    # AC-3: all four public access flags
    public_access_prevention = alltrue([
      aws_s3_bucket_public_access_block.bucket.block_public_acls,
      aws_s3_bucket_public_access_block.bucket.block_public_policy,
      aws_s3_bucket_public_access_block.bucket.ignore_public_acls,
      aws_s3_bucket_public_access_block.bucket.restrict_public_buckets,
    ])

    # AC-3: ACLs disabled
    uniform_access_enforced = one([
      for r in aws_s3_bucket_ownership_controls.bucket.rule :
      r.object_ownership
    ]) == "BucketOwnerEnforced"

    # AU-11: read from the Object Lock config rather than echoing the variable
    retention_period_days = one([
      for r in aws_s3_bucket_object_lock_configuration.bucket.rule :
      one([for d in r.default_retention : d.days])
    ])

    # CM-6: required tags present on the bucket
    required_tags_present = alltrue([
      for k in keys(local.required_tags) :
      contains(keys(aws_s3_bucket.bucket.tags), k)
    ])

    # SC-12 / SC-13: key rotation
    kms_rotation_enabled     = aws_kms_key.key.enable_key_rotation
    kms_rotation_period_days = aws_kms_key.key.rotation_period_in_days
  }
}