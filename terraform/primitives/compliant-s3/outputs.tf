# Values Terraform hands back after it runs.

output "encryption_algorithm" {
  description = "Server-side encryption algorithm in effect (SC-28 attestation)."
  value = one([
    for rule in aws_s3_bucket_server_side_encryption_configuration.primary.rule :
    rule.apply_server_side_encryption_by_default[0].sse_algorithm
  ])
}

output "compliance_attestation" {
  description = "Computed attestation of the controls this configuration enforces."
  value = {
    # SC-28: encryption at rest
    encryption_algorithm = one([
      for rule in aws_s3_bucket_server_side_encryption_configuration.primary.rule :
      rule.apply_server_side_encryption_by_default[0].sse_algorithm
    ])

    # AC-3: all four public access flags must be true
    public_access_blocked = alltrue([
      aws_s3_bucket_public_access_block.primary.block_public_acls,
      aws_s3_bucket_public_access_block.primary.block_public_policy,
      aws_s3_bucket_public_access_block.primary.ignore_public_acls,
      aws_s3_bucket_public_access_block.primary.restrict_public_buckets,
    ])

    # CM-6 part one: versioning
    versioning_enabled = aws_s3_bucket_versioning.primary.versioning_configuration[0].status == "Enabled"

    # CM-6 part two: required tags (tags_all includes provider default_tags)
    required_tags_present = alltrue([
      for k in ["Project", "Environment", "ManagedBy", "ComplianceScope"] :
      contains(keys(aws_s3_bucket.primary.tags_all), k)
    ])

    # AU-3 / AU-6: access logging destination
    logging_target_bucket = aws_s3_bucket_logging.primary.target_bucket
  }
}
