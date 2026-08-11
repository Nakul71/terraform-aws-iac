# INFRASTRUCTURE AS CODE (IaC) USING TERRAFORM ON AWS

---

## COVER PAGE

| | |
|---|---|
| **Project Title** | Infrastructure as Code (IaC) using Terraform on AWS |
| **Group Number** | Group 4 |
| **Domain** | DevOps & Cloud Architecture |
| **Program** | IBM Internship Program |
| **Academic Year** | 2025–2026 |
| **Submission Date** | July 2026 |
| **Technology Stack** | Terraform (HCL), Amazon Web Services (AWS), Nginx, Git |
| **Repository** | [github.com/Nakul71/terraform-aws-iac](https://github.com/Nakul71/terraform-aws-iac) |

---

## CERTIFICATE OF COMPLETION

This is to certify that the project titled **"Infrastructure as Code (IaC) using Terraform on AWS"** has been successfully designed, developed, and deployed by **Group 4** as part of the IBM Internship Program for the academic year 2025–2026.

The project demonstrates proficiency in cloud infrastructure provisioning, network architecture design, compute automation, object storage security, and modular software engineering using HashiCorp Terraform and Amazon Web Services.

| | |
|---|---|
| **Internal Guide** | Dr. Prateek Raj Gautam |
| **External Guide** | Mr. Rehmat |
| **Head of Department** | Dr. Neeraj Chugh|

---

## ACKNOWLEDGEMENTS

We extend our sincere gratitude to the **IBM Internship Program** for providing the opportunity, technical guidelines, and platform to design and execute this cloud infrastructure project. The mentorship received during this program has been invaluable in understanding real-world DevOps practices and enterprise-grade cloud architecture.

We are grateful to our **college faculty and department** for their continuous academic support and guidance throughout this project. Their encouragement and constructive feedback helped shape the direction and quality of this work.

Special thanks to the **HashiCorp** open-source community for maintaining comprehensive Terraform documentation, tutorials, and best-practice guides that informed the architectural decisions in this project. We also acknowledge the **Amazon Web Services** documentation team for their detailed service-level reference materials.

Finally, we appreciate the broader **DevOps and cloud-native engineering** community whose freely available tutorials, blog posts, and conference talks on Infrastructure as Code, networking fundamentals, and security hardening provided supplementary learning resources throughout this project.

---

## ABSTRACT

Cloud computing has fundamentally transformed how organizations provision, manage, and scale computing infrastructure. However, manual provisioning through graphical web consoles—commonly known as "ClickOps"—introduces significant risks including configuration drift, human error, security misconfigurations, lack of auditability, and non-reproducible deployments.

**Infrastructure as Code (IaC)** addresses these challenges by enabling engineers to define, version-control, and automate cloud resource provisioning through machine-readable configuration files. This project implements a production-inspired IaC solution using **HashiCorp Terraform (v1.15.8)** and **Amazon Web Services (AWS) Free Tier** services.

The implemented architecture establishes a custom Virtual Private Cloud (VPC) with a `10.0.0.0/16` CIDR block, segmented into a public subnet (`10.0.1.0/24`) hosting a web server and a private subnet (`10.0.2.0/24`) reserved for isolated backend workloads. An Internet Gateway (IGW) with associated route tables provides controlled internet connectivity. An Amazon EC2 instance (`t3.micro`) running Amazon Linux 2023 is automatically bootstrapped with Nginx via a user-data shell script, served through a static Elastic IP (EIP). Object storage is configured via Amazon S3 with mandatory AES-256 server-side encryption, object versioning, and strict public access blocking.

All infrastructure resources are encapsulated into **three reusable Terraform modules**: `networking`, `compute`, and `storage`, adhering to the DRY (Don't Repeat Yourself) software engineering principle. The entire infrastructure lifecycle—from creation to verification to destruction—is managed through declarative HCL code, achieving a **100% reduction in manual setup time** and provisioning **15 AWS resources in under 2 minutes**.

**Keywords:** Infrastructure as Code, Terraform, AWS, VPC, EC2, S3, DevOps, Cloud Automation, Modular Architecture, HashiCorp Configuration Language.

---

## TABLE OF CONTENTS

1. [Introduction](#1-introduction)
    - 1.1 Background
    - 1.2 Motivation
    - 1.3 Scope of the Project
2. [Problem Statement](#2-problem-statement)
3. [Objectives](#3-objectives)
4. [Literature Survey & Background](#4-literature-survey--background)
    - 4.1 Cloud Computing Evolution
    - 4.2 Infrastructure as Code (IaC) Paradigm
    - 4.3 Imperative vs. Declarative IaC
    - 4.4 Terraform vs. Alternative Tools
    - 4.5 State Management and Drift Detection
5. [Existing System Analysis](#5-existing-system-analysis)
6. [Proposed System](#6-proposed-system)
7. [AWS Services Overview](#7-aws-services-overview)
    - 7.1 Virtual Private Cloud (VPC)
    - 7.2 Subnets and Availability Zones
    - 7.3 Internet Gateway and Route Tables
    - 7.4 Security Groups
    - 7.5 Elastic Compute Cloud (EC2)
    - 7.6 Elastic IP (EIP)
    - 7.7 Simple Storage Service (S3)
    - 7.8 Identity and Access Management (IAM)
8. [Terraform Overview](#8-terraform-overview)
    - 8.1 What is Terraform?
    - 8.2 HashiCorp Configuration Language (HCL)
    - 8.3 Terraform Core Workflow
    - 8.4 Providers and Plugins
    - 8.5 Modules
    - 8.6 State File Management
9. [System Architecture](#9-system-architecture)
    - 9.1 High-Level Architecture Diagram
    - 9.2 Network Architecture
    - 9.3 Data Flow
10. [Implementation](#10-implementation)
    - 10.1 Environment Setup
    - 10.2 Project Directory Structure
    - 10.3 Networking Module
    - 10.4 Compute Module
    - 10.5 Storage Module
    - 10.6 Root Module Assembly
    - 10.7 Provider and Version Configuration
11. [Code Explanation](#11-code-explanation)
    - 11.1 Networking Module — Detailed Walkthrough
    - 11.2 Compute Module — Detailed Walkthrough
    - 11.3 Storage Module — Detailed Walkthrough
    - 11.4 User Data Script — Detailed Walkthrough
12. [Testing & Verification](#12-testing--verification)
    - 12.1 Terraform Validation
    - 12.2 Terraform Plan Analysis
    - 12.3 Terraform Apply Execution
    - 12.4 Web Server Verification
    - 12.5 AWS Console Verification
13. [Results & Outputs](#13-results--outputs)
14. [Advantages](#14-advantages)
15. [Limitations](#15-limitations)
16. [Future Scope](#16-future-scope)
17. [Conclusion](#17-conclusion)
18. [References](#18-references)
19. [Appendix](#19-appendix)

---

## 1. INTRODUCTION

### 1.1 Background

The rapid adoption of cloud computing has shifted the paradigm of computing infrastructure from physical hardware procurement and data center management to software-defined, on-demand resources. Organizations of all sizes—from startups to Fortune 500 enterprises—now rely on public cloud providers such as Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP) to host their applications, store data, and run business-critical workloads.

With this shift comes a critical operational challenge: how do organizations reliably, consistently, and securely manage thousands of cloud resources across multiple environments (development, staging, production) and multiple teams? The traditional approach of manually configuring resources through web-based graphical user interfaces—termed **"ClickOps"**—introduces significant risks that are incompatible with modern software engineering practices.

### 1.2 Motivation

This project was undertaken as part of the **IBM Internship Program** to gain hands-on experience with industry-standard DevOps tools and cloud architecture practices. The motivation stems from:

1. **Industry Demand:** DevOps and cloud engineering roles consistently rank among the most in-demand positions in the technology sector. Proficiency in Terraform and AWS is a core requirement for these roles.
2. **Academic Application:** The project bridges theoretical knowledge of networking (OSI model, IP addressing, subnetting) with practical cloud implementation.
3. **Portfolio Quality:** A well-documented, modular Terraform project serves as a portfolio artifact for career progression.
4. **Problem-Solving Skills:** The project requires reasoning about network isolation, security boundaries, cost management, and infrastructure lifecycle management—skills directly transferable to enterprise environments.

### 1.3 Scope of the Project

This project encompasses:

- Design and implementation of a multi-tier VPC architecture on AWS.
- Automated provisioning of compute resources (EC2) with web server bootstrapping.
- Secure object storage configuration (S3) with encryption and access controls.
- Modular Terraform code organization following industry best practices.
- Complete infrastructure lifecycle management (create, verify, destroy).
- Comprehensive documentation and presentation suitable for academic submission.

The project intentionally operates within AWS Free Tier limits and avoids cost-incurring services such as NAT Gateways, Load Balancers, and RDS instances, while clearly documenting where these components would exist in a production architecture.

---

## 2. PROBLEM STATEMENT

Organizations relying on manual web-console provisioning of cloud resources face critical operational and security challenges:

**1. Configuration Drift:**
Manual changes made through the AWS Console create discrepancies between the documented (intended) architecture and the actual live configuration. Over time, no one knows the true state of the infrastructure, making debugging, auditing, and disaster recovery extremely difficult.

**2. Human Error:**
A single misconfiguration in a Security Group rule—such as accidentally opening port 22 (SSH) to `0.0.0.0/0` in a production database's firewall—can expose sensitive workloads to the entire internet. Human operators under time pressure or fatigue are prone to such mistakes.

**3. Lack of Version Control:**
Manual console configurations have no commit history, no pull request reviews, no branching strategy, and no audit trail. When something breaks in production, there is no `git blame` or `git revert` to identify and roll back the change.

**4. Environment Inconsistency:**
Replicating identical development, staging, and production environments manually is time-consuming and error-prone. Subtle differences between environments lead to the infamous "works on my machine" problem, now escalated to "works in dev, breaks in production."

**5. Non-Repeatable Deployments:**
Onboarding a new team member or setting up a disaster recovery site requires re-executing the exact same sequence of 50+ manual clicks in the exact same order—a process that is fundamentally unreliable.

**6. No Peer Review Process:**
Infrastructure changes bypass the code review process that application code undergoes. There is no mechanism for a senior engineer to review a proposed Security Group change before it goes live.

---

## 3. OBJECTIVES

The primary engineering objectives of this project are:

1. **Automated Provisioning:** Eliminate 100% of manual AWS Console intervention by defining all infrastructure in HashiCorp Configuration Language (HCL).

2. **Modular Design:** Organize infrastructure code into three decoupled, reusable Terraform modules (`networking`, `compute`, `storage`) that can be independently versioned, tested, and reused across environments.

3. **Network Isolation:** Implement a Virtual Private Cloud (VPC) with explicit public-private subnet segmentation, demonstrating multi-tier network architecture principles.

4. **Automated Web Server Deployment:** Bootstrap an Nginx web server on EC2 startup using an unattended `user_data` shell script, requiring zero manual SSH intervention.

5. **Zero-Trust Storage Security:** Enforce Amazon S3 bucket encryption (AES-256), object versioning, and complete public access blocking from the resource definition level.

6. **Least-Privilege Security:** Execute all Terraform deployments using a dedicated IAM user (`terraform-admin`) with scoped permissions, avoiding root account credential exposure.

7. **Idempotent Infrastructure:** Ensure that running `terraform apply` multiple times produces the same result—a core property of well-designed IaC.

8. **Clean Teardown:** Enable complete infrastructure destruction via a single `terraform destroy` command, leaving zero orphaned resources or unexpected AWS charges.

---

## 4. LITERATURE SURVEY & BACKGROUND

### 4.1 Cloud Computing Evolution

Cloud computing has evolved through three major service models:

| Model | Description | Example |
|-------|-------------|---------|
| **IaaS** (Infrastructure as a Service) | Virtual machines, networks, storage | AWS EC2, VPC, S3 |
| **PaaS** (Platform as a Service) | Runtime environments, databases | AWS Elastic Beanstalk, Heroku |
| **SaaS** (Software as a Service) | End-user applications | Gmail, Salesforce |

This project operates at the **IaaS level**, directly provisioning and managing virtual infrastructure components. The AWS provider serves as the IaaS platform, offering over 200 individual services ranging from compute (EC2) to storage (S3) to networking (VPC).

### 4.2 Infrastructure as Code (IaC) Paradigm

Infrastructure as Code is the practice of managing and provisioning computing infrastructure through machine-readable definition files rather than physical hardware configuration or interactive configuration tools. The key principles of IaC are:

- **Declarative Definitions:** Engineers define the *desired end state*, not the step-by-step procedure to reach it.
- **Version Control:** Infrastructure definitions are stored in Git, enabling commit history, branching, pull requests, and rollbacks.
- **Idempotency:** Applying the same configuration multiple times produces the same result.
- **Self-Documenting:** The code itself serves as living documentation of the infrastructure.
- **Testable:** Infrastructure can be validated, linted, and tested before deployment.

### 4.3 Imperative vs. Declarative IaC

| Aspect | Imperative (e.g., AWS CLI, Ansible) | Declarative (e.g., Terraform, CloudFormation) |
|--------|------|------|
| **Approach** | Define explicit step-by-step commands | Define only the final desired state |
| **Example** | "Create VPC, then create subnet, then create IGW..." | "I want a VPC with these properties" |
| **Ordering** | Engineer specifies execution order | Tool calculates dependency graph |
| **Drift Handling** | Must manually detect and remediate | Automated via `terraform plan` |
| **Learning Curve** | Lower (familiar scripting) | Higher (new syntax, state concepts) |

Terraform uses the **declarative** approach. Engineers write HCL code describing what resources should exist and what properties they should have. Terraform's planning engine calculates the exact delta (diff) between the current state and the desired state, then determines the optimal execution graph automatically using a Directed Acyclic Graph (DAG).

### 4.4 Terraform vs. Alternative Tools

| Tool | Provider Support | Language | State Management | Open Source |
|------|-----------------|----------|------------------|-------------|
| **Terraform** | Multi-cloud (AWS, Azure, GCP, 3000+ providers) | HCL (declarative) | Built-in state file | Yes (BSL) |
| **AWS CloudFormation** | AWS only | JSON/YAML | Managed by AWS | Proprietary |
| **Pulumi** | Multi-cloud | Python, TypeScript, Go | Built-in | Yes |
| **Ansible** | Multi-cloud (imperative) | YAML | No state file | Yes |
| **AWS CDK** | AWS only | Python, TypeScript, Java | Via CloudFormation | Yes |

Terraform was chosen for this project because:
- **Multi-cloud portability:** Skills transfer across AWS, Azure, GCP.
- **Industry adoption:** Terraform is the most widely adopted IaC tool globally.
- **Module ecosystem:** The Terraform Registry hosts thousands of reusable modules.
- **Interview relevance:** Terraform proficiency is a standard requirement for DevOps roles.

### 4.5 State Management and Drift Detection

Terraform maintains a **state file** (`terraform.tfstate`) that maps HCL resource definitions to real-world AWS resource identifiers (ARNs, VPC IDs, Instance IDs, etc.). This state file serves as Terraform's "memory" of what it has created.

During `terraform plan`, Terraform:
1. Reads the current `.tfstate` file.
2. Queries AWS APIs to get the actual state of each resource.
3. Compares the actual state against the desired state in HCL code.
4. Generates an execution plan showing exactly what will be created, modified, or destroyed.

This mechanism enables **drift detection**: if someone manually modifies a Security Group through the AWS Console, Terraform will detect the unauthorized change and propose remediation during the next `terraform plan`.

---

## 5. EXISTING SYSTEM ANALYSIS

The existing (traditional) approach to cloud infrastructure provisioning relies on manual operations:

### Manual Console Provisioning Workflow

1. An engineer logs into the AWS Management Console via a web browser.
2. Navigates to the VPC service dashboard and manually creates a VPC by entering CIDR blocks.
3. Creates subnets one by one, selecting availability zones and CIDR ranges.
4. Creates an Internet Gateway and manually attaches it to the VPC.
5. Creates route tables and manually adds routes and subnet associations.
6. Creates Security Groups and manually adds inbound and outbound rules.
7. Navigates to EC2 and launches an instance, selecting AMI, instance type, subnet, and security group.
8. Allocates an Elastic IP and manually associates it with the instance.
9. SSH connects to the instance and manually installs and configures Nginx.
10. Creates an S3 bucket and manually enables versioning, encryption, and access controls.

### Critical Drawbacks of the Existing System

| Drawback | Impact |
|----------|--------|
| No version history | Cannot trace who changed what, when, or why |
| No peer review | Infrastructure changes bypass code review processes |
| Human error prone | Mistyped CIDR blocks, forgotten rules, wrong AZ selections |
| Slow replication | Reproducing the same setup takes 30-45 minutes of manual clicking |
| No idempotency | Re-running the same steps may fail or create duplicates |
| Audit failure | Cannot demonstrate compliance with security policies |
| Disaster recovery | Rebuilding from scratch after a failure is error-prone |

---

## 6. PROPOSED SYSTEM

The proposed system replaces all manual operations with a **fully automated, code-driven infrastructure provisioning pipeline** using Terraform.

### Key Design Principles

1. **Everything as Code:** Every AWS resource is defined in HCL files stored in Git.
2. **Modular Architecture:** Infrastructure is divided into three self-contained modules, each with its own inputs (`variables.tf`), resources (`main.tf`), and outputs (`outputs.tf`).
3. **Environment Isolation:** The `environments/dev/` directory acts as the root module, allowing future `environments/staging/` and `environments/prod/` directories to reuse the same modules with different parameters.
4. **Security by Default:** Encryption, public access blocking, and least-privilege access are embedded in the resource definitions, not applied as afterthoughts.
5. **Self-Documenting:** Variable descriptions, resource comments, and output labels make the code self-explanatory.

### Proposed System Advantages Over Existing System

| Feature | Existing System (ClickOps) | Proposed System (Terraform IaC) |
|---------|---------------------------|--------------------------------|
| Provisioning Time | 30–45 minutes | < 2 minutes |
| Consistency | Error-prone | 100% deterministic |
| Drift Detection | Not possible | Automated via `terraform plan` |
| Version Control | None | Full Git history |
| Peer Review | None | Pull request workflows |
| Modularity | None | Reusable modules |
| Teardown | Risk of orphaned resources | Single `terraform destroy` command |
| Documentation | Separate wiki/documents | Code IS the documentation |

---

## 7. AWS SERVICES OVERVIEW

### 7.1 Virtual Private Cloud (VPC)

Amazon VPC enables the creation of a logically isolated section of the AWS Cloud where resources are launched in a virtual network defined by the user. Key properties:

- **CIDR Block:** Defines the IP address range. This project uses `10.0.0.0/16`, providing 65,536 private IP addresses.
- **DNS Support:** Both `enable_dns_hostnames` and `enable_dns_support` are set to `true`, allowing instances to receive DNS hostnames.
- **Tenancy:** Default (shared hardware), as dedicated tenancy is not Free Tier eligible.

### 7.2 Subnets and Availability Zones

Subnets are subdivisions of a VPC's IP address range, deployed within specific Availability Zones (AZs).

| Subnet | CIDR Block | Type | Purpose |
|--------|-----------|------|---------|
| Public Subnet | `10.0.1.0/24` (256 IPs) | Public | Hosts EC2 web server with internet access |
| Private Subnet | `10.0.2.0/24` (256 IPs) | Private | Reserved for isolated backend services (databases, internal APIs) |

Both subnets are deployed in `ap-south-1a` (Mumbai), selected dynamically using the `aws_availability_zones` data source.

### 7.3 Internet Gateway and Route Tables

- **Internet Gateway (IGW):** A horizontally scaled, redundant, and highly available VPC component that enables communication between instances in the VPC and the internet. Attached to the VPC.
- **Public Route Table:** Contains a route entry directing all outbound traffic (`0.0.0.0/0`) to the IGW ID. Associated with the public subnet only.
- The private subnet uses the default route table (no IGW route), ensuring instances in it cannot directly reach the internet.

### 7.4 Security Groups

Security Groups act as virtual stateful firewalls at the instance level. This project implements a web server Security Group:

| Direction | Protocol | Port | Source/Destination | Purpose |
|-----------|----------|------|-------------------|---------|
| Inbound | TCP | 80 | `0.0.0.0/0` | HTTP web traffic |
| Inbound | TCP | 443 | `0.0.0.0/0` | HTTPS web traffic |
| Inbound | TCP | 22 | `0.0.0.0/0` | SSH administration |
| Outbound | All | All | `0.0.0.0/0` | System updates, package downloads |

> **Note:** In a production environment, SSH access (port 22) would be restricted to specific IP addresses or accessed through AWS Systems Manager Session Manager. The `0.0.0.0/0` rule is acceptable for this development/demo environment.

### 7.5 Elastic Compute Cloud (EC2)

Amazon EC2 provides resizable virtual servers in the cloud. This project uses:

- **Instance Type:** `t3.micro` (2 vCPUs, 1 GiB RAM) — AWS Free Tier eligible in `ap-south-1`.
- **AMI:** Amazon Linux 2023 (`al2023-ami-2023.*-x86_64`), dynamically selected using the `aws_ami` data source with `most_recent = true`.
- **User Data:** A bash script (`user_data.sh`) that runs automatically on first boot to install and configure Nginx.

### 7.6 Elastic IP (EIP)

An Elastic IP is a static, public IPv4 address allocated to the AWS account. Unlike the default dynamic public IP assigned to EC2 instances (which changes on stop/start), an EIP persists until explicitly released.

- **Why EIP?** Without an EIP, stopping and starting the EC2 instance would assign a new public IP, breaking any DNS records or bookmarked URLs pointing to the server.

### 7.7 Simple Storage Service (S3)

Amazon S3 provides scalable object storage with 99.999999999% (11 nines) durability. This project configures:

- **Unique Naming:** Bucket name is dynamically generated using a `random_id` suffix to ensure global uniqueness (e.g., `ibm-iac-storage-dev-6efceb8b`).
- **Versioning:** Preserves all versions of every object, enabling rollback.
- **Server-Side Encryption (SSE-S3):** AES-256 encryption applied automatically to all stored objects.
- **Public Access Block:** All four public access block settings (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`) are set to `true`.

### 7.8 Identity and Access Management (IAM)

IAM controls authentication and authorization for AWS services. This project follows the **least-privilege principle**:

- A dedicated IAM user (`terraform-admin`) was created specifically for Terraform CLI operations.
- The root account was never used for API access.
- Access keys for `terraform-admin` were configured via `aws configure` on the local machine.
- Credential files and state files are excluded from Git via `.gitignore`.

---

## 8. TERRAFORM OVERVIEW

### 8.1 What is Terraform?

Terraform is an open-source Infrastructure as Code tool created by HashiCorp in 2014. It uses a declarative language called **HashiCorp Configuration Language (HCL)** to define cloud infrastructure across 3,000+ providers including AWS, Azure, GCP, Kubernetes, Docker, and more.

Terraform's core strength is its **provider-agnostic** design: the same workflow (`init → plan → apply → destroy`) works regardless of the target cloud platform.

### 8.2 HashiCorp Configuration Language (HCL)

HCL is a declarative language designed specifically for infrastructure definitions. Key constructs:

| Construct | Purpose | Example |
|-----------|---------|---------|
| `resource` | Declares an infrastructure resource | `resource "aws_vpc" "main" { ... }` |
| `variable` | Defines input parameters | `variable "vpc_cidr" { type = string }` |
| `output` | Exports values after creation | `output "vpc_id" { value = aws_vpc.main.id }` |
| `data` | Queries existing resources | `data "aws_ami" "amazon_linux" { ... }` |
| `module` | Calls a reusable module | `module "networking" { source = "..." }` |
| `provider` | Configures cloud provider | `provider "aws" { region = "ap-south-1" }` |
| `locals` | Defines local computed values | `locals { name_prefix = "${var.project}-${var.env}" }` |

### 8.3 Terraform Core Workflow

```
terraform init    →  Download providers, initialize modules
     ↓
terraform fmt     →  Format code to HashiCorp style conventions
     ↓
terraform validate →  Check syntax and internal consistency
     ↓
terraform plan    →  Preview changes (dry run, no modifications)
     ↓
terraform apply   →  Execute the plan, create/modify/destroy resources
     ↓
terraform destroy →  Delete all managed resources
```

### 8.4 Providers and Plugins

Providers are plugins that translate HCL resource definitions into API calls for specific platforms. This project uses two providers:

| Provider | Version | Purpose |
|----------|---------|---------|
| `hashicorp/aws` | `~> 5.0` | Manages all AWS resources (VPC, EC2, S3, etc.) |
| `hashicorp/random` | `~> 3.0` | Generates random values for unique S3 bucket naming |

### 8.5 Modules

Terraform modules are self-contained packages of HCL configuration. They promote:

- **Reusability:** Write once, use across multiple environments.
- **Encapsulation:** Hide complexity behind clean input/output interfaces.
- **Separation of Concerns:** Each module handles one responsibility.
- **Testability:** Modules can be independently validated and planned.

This project implements three custom modules:

| Module | Responsibility | Resources Managed |
|--------|---------------|-------------------|
| `networking` | Network infrastructure | VPC, 2 Subnets, IGW, Route Table, Route Table Association, Security Group |
| `compute` | Compute infrastructure | AMI data source, EC2 Instance, EIP, EIP Association |
| `storage` | Storage infrastructure | Random ID, S3 Bucket, Versioning, Encryption, Public Access Block |

### 8.6 State File Management

The Terraform state file (`terraform.tfstate`) is a JSON document that records:

- The unique ID of every resource Terraform manages (e.g., `vpc-0f277b1d2c98ef780`).
- The current configuration of each resource as last known by Terraform.
- Dependencies between resources.
- Output values.

**In this project**, the state file is stored locally in `environments/dev/terraform.tfstate`. In production environments, it would be stored in an S3 backend with DynamoDB state locking to support multi-engineer concurrent access.

> **Important:** The state file may contain sensitive data (resource IDs, IP addresses). It is excluded from Git via `.gitignore`.

---

## 9. SYSTEM ARCHITECTURE

### 9.1 High-Level Architecture Diagram

```
+─────────────────────────────────────────────────────────────────────────────+
│                             AWS REGION (ap-south-1)                        │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                      VPC (10.0.0.0/16)                             │   │
│   │                  DNS Hostnames: Enabled                             │   │
│   │                  DNS Support:   Enabled                             │   │
│   │                                                                     │   │
│   │   ┌───────────────────────────────┐   ┌─────────────────────────┐  │   │
│   │   │  Public Subnet               │   │  Private Subnet         │  │   │
│   │   │  CIDR: 10.0.1.0/24          │   │  CIDR: 10.0.2.0/24     │  │   │
│   │   │  AZ: ap-south-1a            │   │  AZ: ap-south-1a       │  │   │
│   │   │  Auto-assign Public IP: Yes  │   │  No Internet Access    │  │   │
│   │   │                              │   │                         │  │   │
│   │   │  ┌──────────────────────┐   │   │  ┌───────────────────┐  │  │   │
│   │   │  │ EC2 Instance         │   │   │  │ Reserved for:     │  │  │   │
│   │   │  │ Type: t3.micro       │   │   │  │ - RDS Database    │  │  │   │
│   │   │  │ OS: Amazon Linux 2023│   │   │  │ - Internal APIs   │  │  │   │
│   │   │  │ App: Nginx (Port 80) │   │   │  │ - Backend Workers │  │  │   │
│   │   │  │ EIP: Static Public IP│   │   │  └───────────────────┘  │  │   │
│   │   │  └──────────────────────┘   │   │                         │  │   │
│   │   │         │                    │   └─────────────────────────┘  │   │
│   │   │  ┌──────┴─────────────┐     │                                │   │
│   │   │  │ Security Group     │     │                                │   │
│   │   │  │ Inbound:           │     │                                │   │
│   │   │  │  HTTP (80)  ✓     │     │                                │   │
│   │   │  │  HTTPS (443) ✓    │     │                                │   │
│   │   │  │  SSH (22)   ✓     │     │                                │   │
│   │   │  │ Outbound: All ✓   │     │                                │   │
│   │   │  └────────────────────┘     │                                │   │
│   │   └───────────────────────────────┘                              │   │
│   │              │                                                    │   │
│   │              ▼                                                    │   │
│   │    ┌──────────────────┐                                          │   │
│   │    │ Public Route Table│  Route: 0.0.0.0/0 → IGW               │   │
│   │    └──────────────────┘                                          │   │
│   │              │                                                    │   │
│   │              ▼                                                    │   │
│   │    ┌──────────────────┐                                          │   │
│   │    │ Internet Gateway  │  ← Attached to VPC                     │   │
│   │    └──────────────────┘                                          │   │
│   └─────────────│────────────────────────────────────────────────────┘   │
│                  │                                                        │
│                  ▼                                                        │
│         [ Public Internet ]                                              │
│                                                                           │
│   ┌─────────────────────────────────────────────────────────────────────┐ │
│   │                  S3 Storage Bucket (Encrypted)                      │ │
│   │  Name: ibm-iac-storage-dev-<random>                                │ │
│   │  ┌─────────────┬──────────────────┬─────────────────────────────┐  │ │
│   │  │ AES-256 SSE │ Versioning: ON   │ Public Access: BLOCKED      │  │ │
│   │  └─────────────┴──────────────────┴─────────────────────────────┘  │ │
│   └─────────────────────────────────────────────────────────────────────┘ │
+─────────────────────────────────────────────────────────────────────────────+
```

### 9.2 Network Architecture

The network architecture follows a **two-tier subnet model**:

1. **Public Tier:** The public subnet (`10.0.1.0/24`) has a route table entry directing all outbound traffic to the Internet Gateway. Instances in this subnet can both receive inbound connections from the internet (via their public IP) and initiate outbound connections.

2. **Private Tier:** The private subnet (`10.0.2.0/24`) uses the default VPC route table, which has no route to the Internet Gateway. Instances in this subnet are isolated from direct internet access, making it suitable for databases and internal services.

> **Design Decision:** A NAT Gateway was intentionally omitted to stay within AWS Free Tier limits. In production, a NAT Gateway would allow private subnet instances to make outbound internet connections (e.g., for package updates) while remaining unreachable from inbound internet traffic.

### 9.3 Data Flow

1. A user on the public internet sends an HTTP request to the Elastic IP address.
2. The request passes through the Internet Gateway attached to the VPC.
3. The route table directs the request to the public subnet.
4. The Security Group evaluates the inbound rules: port 80 (HTTP) is allowed from `0.0.0.0/0`.
5. The request reaches the EC2 instance running Nginx on port 80.
6. Nginx processes the request and returns the HTML landing page.
7. The response follows the reverse path back to the user.

---

## 10. IMPLEMENTATION

### 10.1 Environment Setup

The following tools were installed and configured prior to development:

| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | v1.15.8 | Infrastructure as Code engine |
| AWS CLI | v2.25 | AWS credential management and CLI operations |
| Git | v2.49 | Version control |
| Antigravity IDE | — | Integrated development environment |

AWS CLI was configured with credentials for the `terraform-admin` IAM user:

```bash
aws configure
# AWS Access Key ID: AKIA*************
# AWS Secret Access Key: ****************************
# Default region name: ap-south-1
# Default output format: json
```

### 10.2 Project Directory Structure

```
terraform-aws-iac/
│
├── README.md                          # Professional GitHub landing page
├── LICENSE                            # MIT License
├── .gitignore                         # Excludes state files, secrets, credentials
│
├── architecture/
│   └── architecture.png               # Architecture diagram
│
├── docs/
│   ├── report.md                      # This document (Academic report)
│   ├── presentation/
│   │   └── presentation.md            # 14-slide presentation deck
│   └── screenshots/
│       └── .gitkeep                   # Placeholder for AWS console screenshots
│
├── modules/
│   ├── networking/                    # VPC, Subnets, IGW, Route Tables, SG
│   │   ├── main.tf                   # Resource definitions (118 lines)
│   │   ├── variables.tf              # Input parameters (36 lines)
│   │   └── outputs.tf                # Exported values (20 lines)
│   │
│   ├── compute/                       # EC2 Instance, EIP, User Data
│   │   ├── main.tf                   # Resource definitions (49 lines)
│   │   ├── variables.tf              # Input parameters (28 lines)
│   │   ├── outputs.tf                # Exported values (15 lines)
│   │   └── user_data.sh              # Bootstrap script (151 lines)
│   │
│   └── storage/                       # S3 Bucket, Encryption, Public Block
│       ├── main.tf                   # Resource definitions (46 lines)
│       ├── variables.tf              # Input parameters (18 lines)
│       └── outputs.tf                # Exported values (15 lines)
│
└── environments/
    └── dev/                           # Development environment root module
        ├── main.tf                   # Module calls (37 lines)
        ├── variables.tf              # Environment parameters (48 lines)
        ├── outputs.tf                # Aggregated outputs (40 lines)
        ├── providers.tf              # AWS provider + default tags (12 lines)
        ├── versions.tf               # Version constraints (15 lines)
        └── terraform.tfvars.example  # Example variable values
```

### 10.3 Networking Module

**File:** `modules/networking/main.tf`

This module creates 7 AWS resources that form the network foundation:

```hcl
# 1. Custom Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 2. Internet Gateway (IGW) for Internet Connectivity
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 3. Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 4. Private Subnet (Isolated - No Direct Internet Gateway Access)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 5. Public Route Table (Directs outbound traffic to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 6. Route Table Association for Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 7. Web Server Security Group (Stateful Firewall)
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Security group for Nginx web server allowing HTTP, HTTPS, and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

### 10.4 Compute Module

**File:** `modules/compute/main.tf`

This module creates 3 AWS resources plus a data source:

```hcl
# Data source to dynamically get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance running Nginx
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-server"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Elastic IP (EIP) to ensure persistent public IP across reboots
resource "aws_eip" "web_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-eip"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Associate EIP with EC2 Instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web_eip.id
}
```

### 10.5 Storage Module

**File:** `modules/storage/main.tf`

This module creates 5 AWS resources:

```hcl
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 1. S3 Bucket
resource "aws_s3_bucket" "storage" {
  bucket        = "${var.bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-s3"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 2. S3 Bucket Versioning Configuration
resource "aws_s3_bucket_versioning" "storage_versioning" {
  bucket = aws_s3_bucket.storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Server-Side Encryption Configuration (SSE-S3 AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "storage_encryption" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. S3 Block Public Access (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "storage_public_block" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### 10.6 Root Module Assembly

**File:** `environments/dev/main.tf`

The root module ties all child modules together:

```hcl
# Data source to dynamically get available AZs in current region
data "aws_availability_zones" "available" {
  state = "available"
}

# 1. Networking Module
module "networking" {
  source              = "../../modules/networking"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = data.aws_availability_zones.available.names[0]
  environment         = var.environment
  project_name        = var.project_name
}

# 2. Compute Module
module "compute" {
  source            = "../../modules/compute"
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.networking.web_security_group_id
  instance_type     = var.instance_type
  environment       = var.environment
  project_name      = var.project_name
}

# 3. Storage Module
module "storage" {
  source       = "../../modules/storage"
  bucket_prefix = var.s3_bucket_prefix
  environment   = var.environment
  project_name  = var.project_name
}
```

### 10.7 Provider and Version Configuration

**File:** `environments/dev/providers.tf`

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
```

**File:** `environments/dev/versions.tf`

```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
```

---

## 11. CODE EXPLANATION

### 11.1 Networking Module — Detailed Walkthrough

**`aws_vpc "main"`:** Creates the foundational network boundary. The `10.0.0.0/16` CIDR block provides 65,536 IP addresses. DNS hostnames are enabled so EC2 instances receive both public and private DNS names, which is necessary for applications that rely on hostname resolution.

**`aws_internet_gateway "igw"`:** The IGW is the VPC's bridge to the public internet. It is a managed AWS service that requires no sizing, scaling, or availability configuration. Without an IGW, no resource in the VPC can communicate with the internet.

**`aws_subnet "public"`:** The `map_public_ip_on_launch = true` setting ensures that any EC2 instance launched in this subnet automatically receives a public IPv4 address. This is essential for the web server to be reachable from the internet.

**`aws_subnet "private"`:** Notice the absence of `map_public_ip_on_launch`. Instances in this subnet receive only private IPs, making them invisible to the internet. This is the correct pattern for database servers and internal services.

**`aws_route_table "public"` + `aws_route_table_association "public"`:** The route table contains a default route (`0.0.0.0/0`) pointing to the IGW. By associating this route table with the public subnet, all outbound traffic from instances in that subnet is directed through the IGW. The private subnet retains the default VPC route table (which has no IGW route), ensuring isolation.

**`aws_security_group "web_sg"`:** The Security Group is stateful, meaning a response to an allowed inbound request is automatically allowed outbound (and vice versa). The egress rule allowing all outbound traffic is necessary for the EC2 instance to download system updates via `dnf update`.

### 11.2 Compute Module — Detailed Walkthrough

**`data "aws_ami" "amazon_linux"`:** This data source queries the AWS AMI registry at plan time to find the latest Amazon Linux 2023 AMI. The `most_recent = true` flag ensures the instance always uses the most current, patched image—a security best practice that avoids hardcoding AMI IDs that become outdated.

**`aws_instance "web"`:** The `vpc_security_group_ids` parameter (an array) attaches the web Security Group from the networking module. The `user_data` parameter accepts a script that runs on first boot. Terraform reads the script file at plan time using `file("${path.module}/user_data.sh")`.

**`aws_eip "web_eip"` + `aws_eip_association "eip_assoc"`:** The EIP is allocated first (unattached), then associated with the EC2 instance. This two-resource pattern is the Terraform best practice because it separates allocation from association, enabling the EIP to persist even if the EC2 instance is replaced.

### 11.3 Storage Module — Detailed Walkthrough

**`random_id "bucket_suffix"`:** S3 bucket names must be globally unique across all AWS accounts worldwide. The `random_id` resource generates a random 4-byte hex suffix (e.g., `6efceb8b`) that is appended to the bucket prefix to ensure uniqueness.

**`aws_s3_bucket "storage"`:** The `force_destroy = true` setting allows `terraform destroy` to delete the bucket even if it contains objects. Without this, Terraform would fail to destroy a non-empty bucket, requiring manual cleanup.

**`aws_s3_bucket_versioning`:** Versioning preserves every version of every object in the bucket. If a file is accidentally overwritten or deleted, previous versions can be restored. This is a critical data protection mechanism.

**`aws_s3_bucket_server_side_encryption_configuration`:** AES-256 encryption is applied automatically to all objects stored in the bucket. This is an at-rest encryption control that protects data even if the underlying storage hardware is compromised.

**`aws_s3_bucket_public_access_block`:** This resource enforces four independent access controls that collectively guarantee no object in the bucket can ever be made public, even if a misconfigured bucket policy attempts to grant public access.

### 11.4 User Data Script — Detailed Walkthrough

The `user_data.sh` script (151 lines) runs on EC2 first boot:

```bash
#!/bin/bash
exec > /var/log/user-data.log 2>&1     # Redirect all output to log file

dnf update -y || yum update -y          # Update system packages
dnf install -y nginx || yum install -y  # Install Nginx web server

cat <<'EOF' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<!-- Full HTML landing page with glassmorphism design -->
<!-- Includes: project branding, tech stack badges, -->
<!-- networking/compute/storage tier descriptions -->
EOF

systemctl start nginx                    # Start Nginx service
systemctl enable nginx                   # Enable on boot
```

Key design decisions:
- **Dual package manager support:** `dnf || yum` ensures compatibility with both AL2023 (dnf) and older Amazon Linux 2 (yum).
- **Logging:** All output is redirected to `/var/log/user-data.log` for debugging via SSH if needed.
- **Heredoc with single quotes:** `<<'EOF'` prevents bash variable expansion inside the HTML content.
- **systemctl enable:** Ensures Nginx restarts automatically if the instance reboots.

---

## 12. TESTING & VERIFICATION

### 12.1 Terraform Validation

```bash
$ terraform validate
Success! The configuration is valid.
```

This confirms:
- All HCL syntax is correct.
- All variable references resolve to defined variables.
- All module source paths are valid.
- All resource attribute types match provider schema expectations.

### 12.2 Terraform Plan Analysis

```bash
$ terraform plan
Plan: 15 to add, 0 to change, 0 to destroy.
```

The 15 resources in the execution plan:

| # | Resource Type | Module | Purpose |
|---|---------------|--------|---------|
| 1 | `aws_vpc` | networking | Virtual Private Cloud |
| 2 | `aws_internet_gateway` | networking | Internet connectivity |
| 3 | `aws_subnet` (public) | networking | Public subnet |
| 4 | `aws_subnet` (private) | networking | Private subnet |
| 5 | `aws_route_table` | networking | Public route table |
| 6 | `aws_route_table_association` | networking | Route table → subnet link |
| 7 | `aws_security_group` | networking | Firewall rules |
| 8 | `aws_instance` | compute | EC2 web server |
| 9 | `aws_eip` | compute | Static public IP |
| 10 | `aws_eip_association` | compute | EIP → EC2 binding |
| 11 | `random_id` | storage | Unique bucket suffix |
| 12 | `aws_s3_bucket` | storage | Object storage bucket |
| 13 | `aws_s3_bucket_versioning` | storage | Version control for objects |
| 14 | `aws_s3_bucket_server_side_encryption_configuration` | storage | AES-256 encryption |
| 15 | `aws_s3_bucket_public_access_block` | storage | Public access prevention |

### 12.3 Terraform Apply Execution

```bash
$ terraform apply -auto-approve

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

ec2_instance_id   = "i-0528e216ad5723a2b"
ec2_public_ip     = "13.204.131.183"
nginx_web_url     = "http://13.204.131.183"
private_subnet_id = "subnet-0fa95961b6d6a1604"
public_subnet_id  = "subnet-087fca4e5e18557bf"
s3_bucket_arn     = "arn:aws:s3:::ibm-iac-storage-dev-6efceb8b"
s3_bucket_name    = "ibm-iac-storage-dev-6efceb8b"
vpc_id            = "vpc-0f277b1d2c98ef780"
```

All 15 resources were created successfully in the `ap-south-1` (Mumbai) region.

### 12.4 Web Server Verification

An HTTP GET request was executed against the Elastic IP to verify end-to-end connectivity:

```bash
$ curl -I http://13.204.131.183
HTTP/1.1 200 OK
Server: nginx/1.26.2
Content-Type: text/html
```

The response confirmed:
- ✅ Internet Gateway routing is functional.
- ✅ Security Group allows inbound port 80 (HTTP).
- ✅ EC2 instance is running and healthy.
- ✅ User-data script executed successfully (Nginx installed and serving).
- ✅ Elastic IP is correctly associated with the instance.
- ✅ Custom HTML landing page is being served.

### 12.5 AWS Console Verification

The following resources were visually verified in the AWS Management Console:

- **VPC Dashboard:** Custom VPC `terraform-aws-iac-dev-vpc` visible with correct CIDR `10.0.0.0/16`.
- **Subnet Dashboard:** Both public (`10.0.1.0/24`) and private (`10.0.2.0/24`) subnets visible.
- **Internet Gateway:** `terraform-aws-iac-dev-igw` attached to the VPC.
- **Route Tables:** Public route table with `0.0.0.0/0 → igw-xxxxx` route.
- **EC2 Dashboard:** Instance `terraform-aws-iac-dev-web-server` running with `t3.micro` type.
- **Elastic IPs:** `13.204.131.183` allocated and associated.
- **S3 Dashboard:** Bucket `ibm-iac-storage-dev-6efceb8b` with versioning enabled and encryption configured.

---

## 13. RESULTS & OUTPUTS

### Deployment Summary

| Metric | Value |
|--------|-------|
| Total Resources Created | 15 |
| Deployment Time | < 2 minutes |
| Manual Steps Required | 0 |
| Terraform Validation Errors | 0 |
| Terraform Plan Errors | 0 |
| Web Server Response Code | HTTP 200 OK |
| Infrastructure Cost | $0.00 (Free Tier) |

### Resource Identification Table

| Resource | AWS ID/ARN |
|----------|-----------|
| VPC | `vpc-0f277b1d2c98ef780` |
| Public Subnet | `subnet-087fca4e5e18557bf` |
| Private Subnet | `subnet-0fa95961b6d6a1604` |
| EC2 Instance | `i-0528e216ad5723a2b` |
| Elastic IP | `13.204.131.183` |
| S3 Bucket | `ibm-iac-storage-dev-6efceb8b` |
| S3 Bucket ARN | `arn:aws:s3:::ibm-iac-storage-dev-6efceb8b` |

### Infrastructure Teardown

```bash
$ terraform destroy -auto-approve

Destroy complete! Resources: 15 destroyed.
```

All 15 resources were cleanly destroyed, confirming zero orphaned resources and zero unexpected charges.

---

## 14. ADVANTAGES

1. **Speed:** Complete multi-tier infrastructure provisioned in under 2 minutes, compared to 30-45 minutes of manual console operations.

2. **Consistency:** Every `terraform apply` produces an identical infrastructure. There is no variation between deployments, eliminating the "works in dev, breaks in prod" problem.

3. **Version Control:** All infrastructure changes are tracked in Git with full commit history, enabling `git blame` for accountability, `git diff` for change review, and `git revert` for rollbacks.

4. **Peer Review:** Infrastructure changes can be submitted as Pull Requests on GitHub, enabling senior engineers to review proposed modifications before they are applied.

5. **Drift Detection:** Running `terraform plan` at any time reveals whether the actual AWS state matches the intended HCL definition, identifying unauthorized manual changes.

6. **Modularity:** The three-module architecture (`networking`, `compute`, `storage`) allows independent development, testing, and reuse. A new environment (staging, production) can be created by simply calling the same modules with different variables.

7. **Self-Documentation:** The HCL code, variable descriptions, and output labels serve as living documentation that is always synchronized with the actual infrastructure.

8. **Clean Teardown:** A single `terraform destroy` command removes all resources, eliminating the risk of forgotten resources accumulating charges.

9. **Idempotency:** Running `terraform apply` on an already-provisioned infrastructure makes no changes, confirming the declarative model works correctly.

10. **Cost Safety:** The `terraform plan` preview allows engineers to review all changes—including potential cost implications—before any resources are created or modified.

---

## 15. LIMITATIONS

1. **Local State File:** The Terraform state file is stored locally on the developer's machine. This prevents multi-engineer collaboration and creates a single point of failure. If the state file is lost, Terraform loses track of all managed resources.

2. **No NAT Gateway:** The private subnet has no outbound internet access because a NAT Gateway was omitted to stay within Free Tier limits (~$30/month if enabled). This means instances in the private subnet cannot download packages or reach external APIs.

3. **Single Availability Zone:** All resources are deployed in a single AZ (`ap-south-1a`). An AZ failure would cause a complete outage. Production architectures deploy across multiple AZs.

4. **No HTTPS Certificate:** The web server serves content over plain HTTP (port 80). Production deployments require TLS/SSL certificates (via AWS Certificate Manager) and HTTPS (port 443).

5. **Open SSH Access:** Port 22 is open to `0.0.0.0/0` (all internet). Production environments should restrict SSH to specific IP addresses or use AWS Systems Manager Session Manager.

6. **No Auto-Scaling:** The single EC2 instance cannot handle traffic spikes. Production architectures use Auto Scaling Groups (ASG) with minimum and maximum instance counts.

7. **No Load Balancer:** Without an Application Load Balancer (ALB), there is no health checking, traffic distribution, or SSL termination.

8. **No CI/CD Pipeline:** Terraform commands are run manually. Production workflows integrate Terraform with CI/CD platforms (GitHub Actions, Jenkins) for automated `plan` on PRs and `apply` on merges.

---

## 16. FUTURE SCOPE

### Short-Term Improvements

1. **Remote State Backend:** Migrate `terraform.tfstate` to an S3 bucket with DynamoDB table locking, enabling multi-engineer concurrent access with state locking to prevent corruption.

2. **CI/CD Pipeline with GitHub Actions:** Implement automated workflows:
   - On Pull Request: Run `terraform fmt -check`, `terraform validate`, `terraform plan`.
   - On Merge to Main: Run `terraform apply -auto-approve`.

3. **SSH Key Pair Integration:** Generate and manage SSH key pairs through Terraform for secure EC2 access.

### Medium-Term Improvements

4. **Multi-AZ High Availability:** Deploy resources across multiple Availability Zones with an Application Load Balancer (ALB) distributing traffic.

5. **Auto Scaling Group (ASG):** Configure automatic horizontal scaling based on CPU utilization or request count metrics.

6. **HTTPS with ACM:** Provision an SSL/TLS certificate through AWS Certificate Manager and terminate HTTPS at the Load Balancer.

7. **RDS Database in Private Subnet:** Deploy a managed PostgreSQL or MySQL database in the private subnet, accessible only from the public subnet's EC2 instances.

### Long-Term Improvements

8. **Multi-Environment Support:** Create `environments/staging/` and `environments/prod/` directories reusing the same modules with different variable values.

9. **Container Orchestration:** Migrate from EC2 instances to Amazon ECS (Elastic Container Service) or EKS (Elastic Kubernetes Service) for containerized workloads.

10. **Monitoring and Alerting:** Integrate AWS CloudWatch for metrics collection, log aggregation, and SNS-based alerting.

11. **Cost Estimation:** Integrate tools like Infracost to automatically estimate the cost impact of infrastructure changes before they are applied.

---

## 17. CONCLUSION

This project successfully demonstrates the design, implementation, testing, and documentation of a production-inspired cloud infrastructure on Amazon Web Services using HashiCorp Terraform as the Infrastructure as Code tool.

By encapsulating networking, compute, and storage layers into clean, reusable Terraform modules, the deployment achieves high levels of security, maintainability, repeatability, and operational efficiency. The entire infrastructure—comprising 15 AWS resources across VPC networking, EC2 compute, and S3 storage—was provisioned in under 2 minutes with zero manual console interaction.

The project demonstrates several industry-standard DevOps practices:
- **Declarative infrastructure management** using HCL.
- **Modular code organization** following the DRY principle.
- **Security-first design** with encrypted storage, subnet isolation, and least-privilege IAM.
- **Complete lifecycle management** from provisioning to verification to teardown.
- **Version-controlled infrastructure** stored in a Git repository.

The project satisfies all requirements of the IBM Internship Program and serves as a portfolio-grade demonstration of DevOps and cloud engineering principles. The skills and architectural patterns developed during this project—Terraform module design, AWS networking, security hardening, and infrastructure lifecycle management—are directly transferable to enterprise cloud environments.

---

## 18. REFERENCES

1. HashiCorp. (2024). *Terraform Documentation.* Retrieved from https://developer.hashicorp.com/terraform/docs

2. Amazon Web Services. (2024). *Amazon VPC User Guide.* Retrieved from https://docs.aws.amazon.com/vpc/latest/userguide/

3. Amazon Web Services. (2024). *Amazon EC2 User Guide.* Retrieved from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/

4. Amazon Web Services. (2024). *Amazon S3 User Guide.* Retrieved from https://docs.aws.amazon.com/AmazonS3/latest/userguide/

5. HashiCorp. (2024). *Terraform AWS Provider Documentation.* Retrieved from https://registry.terraform.io/providers/hashicorp/aws/latest/docs

6. Brikman, Y. (2022). *Terraform: Up and Running* (3rd ed.). O'Reilly Media.

7. HashiCorp. (2024). *Terraform Best Practices.* Retrieved from https://www.terraform-best-practices.com/

8. Amazon Web Services. (2024). *AWS Well-Architected Framework.* Retrieved from https://docs.aws.amazon.com/wellarchitected/latest/framework/

9. Amazon Web Services. (2024). *Amazon Linux 2023 Documentation.* Retrieved from https://docs.aws.amazon.com/linux/al2023/

10. Amazon Web Services. (2024). *AWS Identity and Access Management (IAM) User Guide.* Retrieved from https://docs.aws.amazon.com/IAM/latest/UserGuide/

11. Morris, K. (2020). *Infrastructure as Code: Dynamic Systems for the Cloud Age* (2nd ed.). O'Reilly Media.

12. Amazon Web Services. (2024). *AWS Security Best Practices.* Retrieved from https://docs.aws.amazon.com/security/

---

## 19. APPENDIX

### Appendix A: Complete Variable Definitions

**Root Module Variables (`environments/dev/variables.tf`):**

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_region` | `string` | `ap-south-1` | AWS deployment region |
| `environment` | `string` | `dev` | Environment name tag |
| `project_name` | `string` | `terraform-aws-iac` | Project name tag |
| `vpc_cidr` | `string` | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidr` | `string` | `10.0.1.0/24` | Public subnet CIDR |
| `private_subnet_cidr` | `string` | `10.0.2.0/24` | Private subnet CIDR |
| `instance_type` | `string` | `t3.micro` | EC2 instance type |
| `s3_bucket_prefix` | `string` | `ibm-iac-storage` | S3 bucket name prefix |

### Appendix B: Complete Output Definitions

| Output | Description | Example Value |
|--------|-------------|---------------|
| `vpc_id` | ID of the created VPC | `vpc-0f277b1d2c98ef780` |
| `public_subnet_id` | ID of the public subnet | `subnet-087fca4e5e18557bf` |
| `private_subnet_id` | ID of the private subnet | `subnet-0fa95961b6d6a1604` |
| `ec2_instance_id` | ID of the EC2 instance | `i-0528e216ad5723a2b` |
| `ec2_public_ip` | Elastic public IP address | `13.204.131.183` |
| `nginx_web_url` | Web URL for browser access | `http://13.204.131.183` |
| `s3_bucket_name` | Globally unique bucket name | `ibm-iac-storage-dev-6efceb8b` |
| `s3_bucket_arn` | Amazon Resource Name of bucket | `arn:aws:s3:::ibm-iac-storage-dev-6efceb8b` |

### Appendix C: Terraform Commands Quick Reference

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize working directory, download providers |
| `terraform fmt -recursive` | Format all HCL files to standard style |
| `terraform validate` | Check syntax and internal consistency |
| `terraform plan` | Preview changes without applying |
| `terraform apply` | Apply changes to create/modify resources |
| `terraform apply -auto-approve` | Apply without interactive confirmation |
| `terraform destroy` | Destroy all managed resources |
| `terraform output` | Display output values |
| `terraform state list` | List all resources in state file |
| `terraform state show <resource>` | Show details of a specific resource |

### Appendix D: .gitignore Configuration

```gitignore
# Terraform State (contains sensitive resource IDs and metadata)
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Terraform Variables with Secrets
*.tfvars
!*.tfvars.example

# AWS Credentials (never commit)
.aws/
credentials

# OS and IDE files
.DS_Store
*.swp
.vscode/
.idea/
```

---

*End of Report*
