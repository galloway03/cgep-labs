<h1>GRC Engineering Club - Labs in prep for GRC Certification.</h1>
Welcome to the club! Join me on this hands-on learning journey with the GRC Engineering Club. I have over 17 years of experience in tech and cyber, and I have some experience with programming languages such as Python. Vulnerability/Exposure/Attack Surface Management and SOC automation have been jam the last 10 years, so it's time to put that knowledge to the test and dive into GRC Engineering. Take the checklist out of checklist GRC.

In Module 2, we are working on creating compliant s3 buckets without having to log into the AWS console to configure each rule and check. 

This module is setting the foundation for future ones. We are starting the process of creating compliant buckets across platforms to help reduce the manual labor involved with finding and storing evidence and proving configuration management works. 

| Control | Title | Description |
|---|---|---| 
| **SC-28** | Protection of Information at Rest | The primary bucket must encrypt objects by default. The log bucket too. Server-side encryption with AES-256 is enough for this week. |
| **AC-3** | Access Enforcement | Public access must be blocked on all four vectors. AWS exposes four separate flags for this, and all four have to be true. Three is not enough. They are four independent doors.|
| **CM-6** | Configuration Settings | Enable versioning on the primary bucket so prior object states are recoverable and auditable. Four required tags on every taggable resource: Project, Environment, ManagedBy, ComplianceScope. The clean way to do this is the provider `default_tags` block, so you cannot forget them on a new resource.
| **AU-3** and **AU-6** | Audit record content and review | he primary bucket logs access to the dedicated log bucket. The log bucket needs ownership controls set so it can accept a log-delivery ACL before logging will work. |

2.3 - We build one (1) compliant S3 bucket with 6 controls. 
2.4 - We build on this by creating modules that will create multiple compliant buckets - this reminds me of the Gold Disk: create the one compliant disk that is used any time a system is brought online. The lab here was built with GCP; however, I did mine in AWS. Claude for the win with the conversation
2.5 - We build the evidence vault that holds the evidence for the auditor. This is different from the evidence folder with the file structure, as that one contains the files from the continuous monitoring process

<h1>Lab File Structure</h1>
cgep-labs - root repository
  evidence - where each lab's evidence is stored
    lab-x-x
      lab evidence in json format
  scripts - scripts used throughout
  terraform - 
    modules - packages the resources needed to deploy buckets over and over again. These are the templates (the gold disk) (terraform init and validate)
      compliant-s3
    primitives - call the modules to create the buckets. Run terraform init, apply, and plan in the folder. Each primitive has main, output, variables, README
      compliant-s3
        main.tf
        output.tf
        variables.tf
        README.md
  .gitignore - lists files to ignore
      
This structure will grow with each lab. This is a running document and will be updated as I go. 


