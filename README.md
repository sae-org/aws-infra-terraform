# AWS Infrastructure with Terraform (`aws-infra-tf`)

This repository provisions all AWS infrastructure needed to deploy and scale the `my-website` application.  
It uses **Terraform** with an **S3 backend** for state storage and creates a complete production-ready environment.

---

## 🚀 Features
- **Networking**
  - VPC with public/private subnets
  - Internet Gateway, NAT Gateway, route tables
- **Compute**
  - Launch Template for EC2 instances
  - Auto Scaling Group (ASG) for scaling out/in
- **Load Balancing**
  - Application Load Balancer (ALB) distributing traffic across EC2s
- **Security**
  - Security Groups for ALB, EC2, and SSH access
  - IAM roles for EC2 instances and Ansible
- **State & Locking**
  - Terraform remote backend in S3
  - DynamoDB table for state locking
- **Container Registry**
  - Amazon ECR repository to host website Docker images
- **Optional DNS**
  - Route 53 domain records
  - ACM certificates for HTTPS

---

## 📂 Structure
aws-infra-tf/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
├── vpc/
├── ec2/
├── lb/
├── sg_ec2/
└── iam/


