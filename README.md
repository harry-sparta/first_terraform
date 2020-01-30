# Terraform
## Introduction
This is our first terraform project.
Terraform is an orchestration tool, which will deploy AMIs into the cloud.

It can use many providers and use different types of images & or provisioning.

In our stack we have:
- Chef - configuration management
- Packer - creates immutable images of our machines
- Terraform - is the orchestration tool that will setup the infrastructure in the cloud

Terraform commands so far:
terraform init
terraform refresh
terraform plan
terraform apply
terraform destroy

## First_terraform
This repository is a first 2-tier architecture launched to AWS using terraform and ready AMIs.
- Node sample application
- Mongodb


## Blockers
- Creating a working Mongodb AMI that could be called by the app e.g. http://<app_instance_ip>:3000/posts
