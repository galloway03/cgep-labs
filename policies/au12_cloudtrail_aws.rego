# policies/au12_cloudtrail_aws.rego
# METADATA
# title: AU-12 - Audit Record Generation
# description: "Audit logging is enabled for Cloudtrail"
# custom:
#   control_id: AU-12
#   framework: nist-800-53
#   severity: high
#   remediation: "Enable logging on Cloudtrail resources"
# Test fixture: policies/tests/au12_cloudtrail_test.json
# Run from the repository root:
# conftest test policies/tests/au12_cloudtrail_test.json \
#   --policy policies/au12_cloudtrail_aws.rego \
#   --namespace compliance.au12_aws
#
# The fixture intentionally disables multi-region logging and log-file validation to demonstrate policy violations.

package compliance.au12_aws

import rego.v1

required := {"Project", "Environment", "ManagedBy", "ComplianceScope"} 

# Identify Cloudtrail resources in Terraform plan 
cloudtrails := [trail |
    some trail in input.planned_values.root_module.resources
    trail.type == "aws_cloudtrail"
]

# Fail if no Cloudtrail resource is found
deny contains msg if {
    count(cloudtrails) == 0
    msg := "[AU-12] No Cloudtrail resource found. Enable Cloudtrail."
}

# Fail if a Cloudtrail resource is not multi-region
deny contains msg if {
    some trail in cloudtrails
    object.get(trail.values, "is_multi_region_trail", false) != true
    msg := sprintf(
        "[AU-12] %s: CloudTrail logging must be enabled.",
        [trail.address]
    )
}

# Fail if a Cloudtrail logging is not enabled
deny contains msg if {
    some trail in cloudtrails
    object.get(trail.values, "enable_logging", false) != true
    msg := sprintf(
        "[AU-12] %s: CloudTrail logging must be enabled.",
        [trail.address]
    )
}

# Fail if a Cloudtrail logfile validation is not enabled
deny contains msg if {
    some trail in cloudtrails
    object.get(trail.values, "enable_log_file_validation", false) != true
    msg := sprintf(
        "[AU-12] %s: CloudTrail log file validation should be enabled.",
        [trail.address]
    )
}

# Fail if a Cloudtrail include_global_service_events is not enabled
deny contains msg if {
    some trail in cloudtrails
    object.get(trail.values, "include_global_service_events", false) != true
    msg := sprintf(
        "[AU-12] %s: CloudTrail global service events should be enabled.",
        [trail.address]
    )
}

deny contains msg if {
    some trail in cloudtrails
    object.get(trail.values, "s3_bucket_name", "") == ""
    msg := sprintf(
        "[AU-12] %s: CloudTrail must have an S3 logging destination.",
        [trail.address]
    )
}