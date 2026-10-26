# GRC Engineering Club - Labs in prep for GRC Certification
Welcome to the club! Join me on this hands-on learning journey with the GRC Engineering Club. I have over 17 years of experience in tech and cyber, and I have some experience with programming languages such as Python. Vulnerability/Exposure/Attack Surface Management and SOC automation have been jam the last 10 years, so it's time to put that knowledge to the test and dive into GRC Engineering. Take the checklist out of checklist GRC.

In Module 2, we are working on creating compliant s3 buckets without having to log into the AWS console to configure each rule and check. 

This module is setting the foundation for future ones. We are starting the process of creating compliant buckets across platforms to help reduce the manual labor involved with finding and storing evidence and proving configuration management works. 

| Control | Title | Description |
|---|---|---| 
| **SC-28** | Protection of Information at Rest | The primary bucket must encrypt objects by default. The log bucket too. Server-side encryption with AES-256 is enough for this week. |
| **AC-3** | Access Enforcement | Public access must be blocked on all four vectors. AWS exposes four separate flags for this, and all four have to be true. Three is not enough. They are four independent doors.|
| **CM-6** | Configuration Settings | Enable versioning on the primary bucket so prior object states are recoverable and auditable. Four required tags on every taggable resource: Project, Environment, ManagedBy, ComplianceScope. The clean way to do this is the provider `default_tags` block, so you cannot forget them on a new resource.
| **AU-3** and **AU-6** | Audit record content and review | he primary bucket logs access to the dedicated log bucket. The log bucket needs ownership controls set so it can accept a log-delivery ACL before logging will work. We will use Rego to create the policies based on the controls in question.

## Labs
+ **2.3** - We build one (1) compliant S3 bucket with 6 controls. 
+ **2.4** - We build on this by creating modules that will create multiple compliant buckets - this reminds me of the Gold Disk: create the one compliant disk that is used any time a system is brought online. The lab here was built with GCP; however, I did mine in AWS. *Claude for the win with the conversation*
+ **2.5** - We build the evidence vault that holds the evidence for the auditor. This is different from the evidence folder with the file structure, as that one contains the files from the continuous monitoring process. It reads a workspace, builds a manifest of hashes, uploads a bundle to the vault, and prints a one-line JSON receipt that a pipeline can capture later
+ **3.3** - In this exercise, we are checking that the infrastructure we built in module 2 is compliant.

## Lab File Structure
```
└── cgep-labs
    ├── README.md
    ├── evidence
    │   ├── lab-x-x
    │   │   ├── json files
    ├── output
    ├── scripts
    │   └── script
    ├── terraform
    │   ├── modules
    │   │   └── list of modules and files
    │   └── primitives
    │       ├── compliant-s3
    │       │   ├── README.md
    │       │   ├── main.tf
    │       │   ├── outputs.tf
    │       │   ├── terraform.tfstate
    │       │   ├── terraform.tfstate.backup
    │       │   ├── tfplan
    │       │   └── variables.tf
    │       └── evidence-vault
    │           ├── main.tf
    │           ├── outputs.tf
    │           └── variables.tf
    └── terraform.tfstate
```     
This structure will grow with each lab. This is a running document and will be updated as I go. 


