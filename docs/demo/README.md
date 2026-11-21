# CloudTrail Compliance Assessment Demo

CloudTrail is an AWS service that helps you enable operational and risk auditing, governance, and compliance of your AWS account. This is where user actions within AWS are tracked. This service should also have logging enabled and comply with the framework the organization uses. 

The Rego rules that would be applied can be found here under AU-12 Audit Record Generation
https://github.com/galloway03/cgep-labs/blob/main/policies/au12_cloudtrail_aws.rego 

One note: there is a check to see if specific fields actually exist. Not just if something is enabled or disabled. If the field is missing, the test fails, which is not the most accurate representation of what is happening. 


## Items that were added: 
```
├── README.md
├── docs
│   └── demo
│       └── index.html
├── policies
│   ├── README.md
│   ├── au12_cloudtrail_aws.rego
│   └── tests
└──     ├── au12_cloudtrail_test.json
 ```
This is version 1 of this tool. In reality, we ensure the rules catch configurations missing from resources based on specific NIST controls and security objectives. Full Lab sessions with evidence files are accessible here: 
https://github.com/galloway03/cgep-labs/blob/main/policies/au12_cloudtrail_aws.rego 

Link to demo in browser: https://galloway03.github.io/cgep-labs/ 

Future additions to this interface: 
+ Automated policy evaluation:
  Have OPA/Conftest execute your Rego rules against Terraform plan JSON instead of relying on JavaScript simulations.
+ Automated evidence generation:
  Capture actual evaluation results, timestamps, control mappings, and remediation guidance in downloadable JSON.
+ CI/CD integration:
  Use GitHub Actions to run those assessments when relevant Terraform configurations change, without disrupting your existing S3 workflow.
