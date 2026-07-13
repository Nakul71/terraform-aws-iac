# 🚀 Infrastructure as Code using Terraform on AWS

[![Terraform](https://img.shields.io/badge/Terraform-v1.15.8-7B42BC?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Free%20Tier-FF9900?logo=amazon-aws)](https://aws.amazon.com/free/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![IBM Internship](https://img.shields.io/badge/IBM-Internship%20Project-0530AD?logo=ibm)](https://www.ibm.com/)

> **IBM Internship Project** — A production-inspired Infrastructure as Code solution provisioning AWS infrastructure through reusable, modular, version-controlled Terraform code.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [AWS Services Used](#aws-services-used)
- [Terraform Concepts Used](#terraform-concepts-used)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Deployment Steps](#deployment-steps)
- [Outputs](#outputs)
- [Screenshots](#screenshots)
- [Lessons Learned](#lessons-learned)
- [Future Improvements](#future-improvements)

---

## Overview

This project provisions a complete, production-inspired AWS infrastructure using Terraform. Instead of manually clicking through the AWS Console, every resource is defined as code — reviewable, repeatable, and version-controlled.

**What gets deployed:**
- A custom Virtual Private Cloud (VPC) with public and private subnets
- An EC2 instance running Nginx, accessible via Elastic IP
- An S3 bucket with versioning, encryption, and public access blocked
- Proper security groups, routing, and network isolation

---

## Architecture

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet (10.0.1.0/24)         Private Subnet (10.0.2.0/24)
    │                                       │
    ├── EC2 + Nginx + Elastic IP            └── Reserved (future RDS)
    └── Security Group (80/443/22)

VPC: 10.0.0.0/16
S3 Bucket: Versioning + SSE-S3 + Public Access Block
```

> See `architecture/architecture.png` for the visual diagram.

---

## AWS Services Used

| Service | Purpose |
|---------|---------|
| VPC | Isolated network for all resources |
| Subnets (Public + Private) | Network segmentation |
| Internet Gateway | Enables internet access for public subnet |
| Route Table | Directs traffic from subnet to internet |
| Security Groups | Firewall rules for EC2 |
| EC2 (t2.micro) | Web server — Free Tier eligible |
| Elastic IP | Static public IP for EC2 |
| S3 | Object storage with security controls |

---

## Terraform Concepts Used

- Providers & Versions
- Resources
- Variables & Outputs
- Locals
- Data Sources
- Modules (networking, compute, storage)
- `terraform.tfvars`
- State Management (local + remote concept)
- `terraform init`, `validate`, `fmt`, `plan`, `apply`, `destroy`

---

## Project Structure

```
terraform-aws-iac/
├── README.md
├── LICENSE
├── .gitignore
├── architecture/
│   └── architecture.png
├── docs/
│   ├── report.md
│   ├── screenshots/
│   └── presentation/
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── user_data.sh
│   └── storage/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── versions.tf
│       └── terraform.tfvars.example
└── interview_prep/
    └── questions.md
```

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate IAM permissions
- AWS Account (Free Tier eligible)

---

## Deployment Steps

```bash
# 1. Clone the repository
git clone git@github.com:YOUR_USERNAME/terraform-aws-iac.git
cd terraform-aws-iac/environments/dev

# 2. Copy and fill in your variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 3. Initialize Terraform
terraform init

# 4. Validate and format
terraform validate
terraform fmt

# 5. Preview changes
terraform plan

# 6. Apply infrastructure
terraform apply

# 7. Destroy when done (avoid charges)
terraform destroy
```

---

## Outputs

After `terraform apply`, you will see:

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the created VPC |
| `public_subnet_id` | ID of the public subnet |
| `ec2_public_ip` | Elastic IP of the web server |
| `s3_bucket_name` | Name of the S3 bucket |
| `nginx_url` | Direct URL to access Nginx |

---

## Screenshots

> Screenshots will be added after deployment in `docs/screenshots/`

---

## Lessons Learned

- Always use IAM users instead of root account credentials
- Remote state (S3 backend) is essential for team collaboration
- Security groups are stateful — return traffic is automatically allowed
- Terraform modules enable reusable, maintainable infrastructure code
- `.gitignore` must exclude `.tfstate` and `.tfvars` from day one

---

## Future Improvements

- [ ] Add RDS instance in private subnet
- [ ] Configure NAT Gateway for private subnet internet access
- [ ] Implement S3 remote backend for Terraform state
- [ ] Add CloudWatch monitoring and alarms
- [ ] Integrate with GitHub Actions for CI/CD
- [ ] Add Application Load Balancer for high availability

---

## Author

**Nakul Yadav** — IBM Internship 2026

---

## License

[MIT](LICENSE)
