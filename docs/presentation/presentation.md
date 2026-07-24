# 📊 Slide Deck: Infrastructure as Code (IaC) using Terraform on AWS

**Project Title:** Infrastructure as Code (IaC) using Terraform on AWS  
**Presenter:** Nakul Yadav  
**Program:** IBM Internship 2026  
**Repository:** [github.com/Nakul71/terraform-aws-iac](https://github.com/Nakul71/terraform-aws-iac)  

---

## 📌 Slide 1: Title Slide

### Infrastructure as Code (IaC) using Terraform on AWS
*A Modular, Production-Inspired AWS Infrastructure Architecture*

- **Author:** Nakul Yadav
- **Program:** IBM Internship Submission
- **Stack:** Terraform | AWS Free Tier | Nginx | Git

> **Speaker Notes:** "Good morning/afternoon evaluators. Today I am presenting my IBM internship project: building a production-grade, modular cloud infrastructure on AWS entirely using Infrastructure as Code with Terraform."

---

## 📌 Slide 2: Executive Summary & Objective

### Key Objectives
- **Zero ClickOps:** 100% of cloud resources provisioned via declarative HCL code.
- **Modular Design:** Decoupled child modules for `networking`, `compute`, and `storage`.
- **Security Hardening:** Least-privilege IAM, encrypted S3 bucket, isolated subnetting.
- **Automated Web Server:** Nginx bootstrapped automatically on EC2 startup via user-data.

> **Speaker Notes:** "The goal of this project was not just to spin up a virtual machine, but to build an enterprise-inspired cloud architecture that can be audited, reviewed in Git, and deployed in under 2 minutes."

---

## 📌 Slide 3: Problem Statement — Why IaC?

### Manual Console Management ("ClickOps") Pitfalls
- **Configuration Drift:** Manual UI changes create undocumented infrastructure state.
- **Human Mistakes:** Unintentional public exposure of storage or open firewall ports.
- **No Versioning:** Cannot roll back or review changes via Pull Requests.
- **Time Inefficiency:** Re-creating multi-tier environments manually takes hours.

> **Speaker Notes:** "Clicking around the AWS Console leads to missing configurations and security vulnerabilities. Terraform solves this by treating infrastructure as application source code."

---

## 📌 Slide 4: System Architecture Diagram

```
[ Internet ] ──> [ Internet Gateway ] ──> [ Public Subnet (10.0.1.0/24) ]
                                                  │
                                          EC2 + EIP (13.204.131.183)
                                          Web SG (Ports 80, 443, 22)
                                                  │
                                        [ Private Subnet (10.0.2.0/24) ]
                                          (Reserved for Database Tier)

[ S3 Storage Bucket ] ──> AES-256 Encryption | Versioning | Public Block
```

> **Speaker Notes:** "Here is our VPC architecture. We have a public subnet hosting our EC2 web server, a private subnet reserved for internal workloads, and an encrypted S3 bucket."

---

## 📌 Slide 5: AWS Services Breakdown

| Service | Architecture Role | Configuration Details |
|---|---|---|
| **VPC** | Network Boundary | CIDR `10.0.0.0/16`, DNS hostnames enabled |
| **Subnets** | Isolation | Public (`10.0.1.0/24`), Private (`10.0.2.0/24`) |
| **IGW & Routes** | Internet Gateway | Route table directing `0.0.0.0/0` to IGW |
| **EC2 & EIP** | Web Compute | `t3.micro` Amazon Linux 2023 + Static EIP |
| **Security Group** | Firewall | Stateful inbound rules for ports 80, 443, 22 |
| **S3 Storage** | Object Storage | AES-256 SSE, Versioning, Public Access Block |

> **Speaker Notes:** "Each AWS service was selected to fulfill a specific operational requirement while strictly adhering to AWS Free Tier limits."

---

## 📌 Slide 6: Modular Repository Structure

```
environments/dev/          <-- Root Module (main, variables, outputs)
modules/
  ├── networking/          <-- VPC, Subnets, IGW, Route Table, Security Group
  ├── compute/             <-- EC2 Instance, Elastic IP, User Data script
  └── storage/             <-- S3 Bucket, Encryption, Public Block
```

> **Speaker Notes:** "We followed industry best practices by separating code into reusable modules. The dev environment simply calls these modules with environment-specific parameters."

---

## 📌 Slide 7: Terraform Workflow & Execution

### Core Lifecycle Loop
1. `terraform fmt -recursive` — Code formatting compliance
2. `terraform init` — Download provider plugins & initialize modules
3. `terraform validate` — Syntax and reference check
4. `terraform plan` — Preview exact changes (15 resources to add)
5. `terraform apply` — Automated API creation in AWS

> **Speaker Notes:** "Terraform builds a Directed Acyclic Graph (DAG) of all resources to determine dependency creation order automatically."

---

## 📌 Slide 8: Compute Automation — User Data Script

### Bootstrapping EC2 Unassisted
- Updates system packages automatically (`dnf update -y`).
- Installs Nginx web server daemon (`dnf install -y nginx`).
- Injects custom HTML landing page with project branding.
- Enables and starts the Nginx service on port 80.

> **Speaker Notes:** "When the EC2 instance launches, it runs a bash user-data script that installs Nginx without requiring SSH intervention."

---

## 📌 Slide 9: Security & Compliance Controls

- **Dedicated IAM User:** Executed via `terraform-admin` CLI user (No root account keys).
- **Zero-Trust Storage:** S3 bucket has public access blocked and AES-256 encryption enabled.
- **Git Security:** Secrets, credentials, and state files excluded via `.gitignore`.

> **Speaker Notes:** "Security was embedded from step zero. We avoided using root credentials and enforced strict S3 public block policies."

---

## 📌 Slide 10: Live Results & Deployment Verification

### Real Terraform Apply Outputs
```hcl
Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:
ec2_instance_id = "i-0528e216ad5723a2b"
ec2_public_ip   = "13.204.131.183"
nginx_web_url   = "http://13.204.131.183"
s3_bucket_name  = "ibm-iac-storage-dev-6efceb8b"
vpc_id          = "vpc-0f277b1d2c98ef780"
```

> **Speaker Notes:** "Here are the actual live outputs from `terraform apply`. All 15 resources were created successfully in the ap-south-1 region."

---

## 📌 Slide 11: Live Web Application Proof

- **URL:** `http://13.204.131.183`
- **HTTP Status:** `200 OK`
- **Response Content:** `🚀 Infrastructure Deployed via Terraform — IBM Internship Project`

> **Speaker Notes:** "Curling the Elastic IP returns our Nginx landing page, confirming end-to-end network routing, security group rules, and EC2 user-data execution."

---

## 📌 Slide 12: Engineering Challenges & Solutions

| Challenge | Solution Implemented |
|---|---|
| IPv6 DNS timeouts during provider download | Created local provider mirror cache for offline/stable initialization |
| Free Tier instance mismatch | Querying `aws ec2 describe-instance-types` to select `t3.micro` for ap-south-1 |
| User-data boot logging syntax | Streamlined bash redirection to `/var/log/user-data.log` for clean execution |

> **Speaker Notes:** "During development, we resolved network resolution challenges by establishing local provider caching and verified Free Tier instance compatibility."

---

## 📌 Slide 13: Future Scope & Roadmap

- **Remote State:** Migrate `.tfstate` to S3 backend with DynamoDB state locking.
- **CI/CD Pipeline:** Implement GitHub Actions for automated `terraform plan` on PRs.
- **Multi-AZ HA:** Add Application Load Balancer (ALB) and Auto Scaling Group (ASG).

> **Speaker Notes:** "For production scale, the next logical steps are remote state locking and multi-AZ load balancing."

---

## 📌 Slide 14: Conclusion & Q&A

### Summary
- Fully automated, modular AWS infrastructure deployed with Terraform.
- 15 AWS resources provisioned in < 2 minutes with zero manual UI steps.
- Code published at [github.com/Nakul71/terraform-aws-iac](https://github.com/Nakul71/terraform-aws-iac).

**Thank You! Questions?**

> **Speaker Notes:** "Thank you for your time. I am now open to your questions."
