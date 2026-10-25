<h1>GRC Engineering Club - Labs in prep for GRC Certification.</h1>
Welcome to the club! Join me on this hands-on learning journey with the GRC Engineering Club. I have over 17 years of experience in tech and cyber, and I have some experience with programming languages such as Python. Vulnerability/Exposure/Attack Surface Management and SOC automation have been jam the last 10 years, so it's time to put that knowledge to the test and dive into GRC Engineering. Take the checklist out of checklist GRC.

In Module 2, we are working on creating compliant s3 buckets without having to log into the AWS console to configure each rule and check. 

This module is setting the foundation for future ones. We are starting the process of creating compliant buckets across platforms to help reduce the manual labor involved with finding and storing evidence and proving configuration management works.
2.3 - We build one (1) compliant S3 bucket with 6 controls. 
2.4 - We build on this by creating modules that will create multiple compliant buckets - this reminds me of the Gold Disk: create the one compliant disk that is used any time a system is brought online. The lab here was built with GCP; however, I did mine in AWS. Claude for the win with the conversation
2.5 - We build the evidence vault that holds the evidence for the auditor. This is different from the evidence folder with the file structure, as that one contains the files from the continuous monitoring process

<h1>Lab File Structure</h1>
cgep-labs - root repository
  evidence - where each lab's evidence is stored
    lab-x-x
  scripts - scripts used throughout
  terraform - 
    modules - packages the resources needed to deploy buckets over and over again. These are the templates (the gold disk) (terraform init and validate)
      compliant-s3
    primitives - call the modules to create the buckets. terraform init, apply, and plan are run in the folder
      compliant-s3
      compliant-prod
      compliant-negative
  .gitignore - lists files to ignore
      
This structure will grow with each lab. This is a running document and will be updated as I go. 


