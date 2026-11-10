# CloudTrail Compliance Assessment Demo

This application was created to demonstrate some of the techniques utilized in the GRC Engineering Club. For this demo, we added logging for CloudTrail resources as this was the last thing added in the labs. This is a demo with synthetic data using real Rego rules.

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
This is version 1 of this tool. We ensure the rules catch configurations missing from resources based on specific NIST controls and security objectives. Full Lab sessions with evidence files are accessible here: 
https://github.com/galloway03/cgep-labs/blob/main/policies/au12_cloudtrail_aws.rego

Link to demo in browser: https://galloway03.github.io/cgep-labs/demo/ 

Future phases of this from the lab: 
+ Automated policy evaluation:
  Have OPA/Conftest execute your Rego rules against Terraform plan JSON instead of relying on JavaScript simulations.
+ Automated evidence generation:
  Capture actual evaluation results, timestamps, control mappings, and remediation guidance in downloadable JSON.
+ CI/CD integration:
  Use GitHub Actions to run those assessments when relevant Terraform configurations change, without disrupting your existing S3 workflow.
