# INFRASTRUCTURE AS CODE (IaC) USING TERRAFORM ON AWS
## Slide Deck — Group 4 | IBM Internship Program 2026

---

## SLIDE 1: TITLE SLIDE

### Infrastructure as Code (IaC) using Terraform on AWS
*A Modular, Production-Inspired AWS Infrastructure Architecture*

| | |
|---|---|
| **Group Number** | Group 4 |
| **Program** | IBM Internship 2026 |
| **Domain** | DevOps & Cloud Architecture |
| **Technology Stack** | Terraform (HCL) · AWS Free Tier · Nginx · Git |
| **Repository** | [github.com/Nakul71/terraform-aws-iac](https://github.com/Nakul71/terraform-aws-iac) |

> **Speaker Notes:** "Good morning/afternoon, respected evaluators. Today we are presenting our IBM internship project: designing and deploying a production-grade, modular cloud infrastructure on Amazon Web Services entirely using Infrastructure as Code with HashiCorp Terraform. Our project demonstrates how modern enterprises automate infrastructure provisioning to achieve speed, security, and repeatability."

---

## SLIDE 2: AGENDA

### Presentation Roadmap

1. ❓ Problem Statement — Why IaC?
2. 🎯 Objectives — What We Set Out to Achieve
3. 📚 Background — IaC Concepts & Terraform
4. 🏗️ System Architecture — AWS Multi-Tier Design
5. ☁️ AWS Services Used — VPC, EC2, S3, IAM
6. 📦 Modular Code Structure — How We Organized It
7. ⚙️ Terraform Workflow — Init → Plan → Apply
8. 🖥️ Compute Automation — User Data & Nginx
9. 🔒 Security Controls — IAM, Encryption, Access Blocking
10. ✅ Live Results — Deployment Outputs & Verification
11. 📊 Advantages & Comparison — ClickOps vs IaC
12. 🔮 Future Scope — What's Next
13. 📝 Conclusion & Q&A

> **Speaker Notes:** "Here is the roadmap for our presentation. We'll start with the problem we're solving, walk through the architecture, show live deployment results, and conclude with future improvements."

---

## SLIDE 3: PROBLEM STATEMENT — WHY IaC?

### Manual Console Provisioning ("ClickOps") Pitfalls

| Problem | Risk Level | Impact |
|---------|-----------|--------|
| **Configuration Drift** | 🔴 High | Manual UI changes create undocumented infrastructure state |
| **Human Error** | 🔴 High | Mistyped CIDR blocks, open firewall ports, wrong AZ selections |
| **No Version Control** | 🟡 Medium | Cannot review, roll back, or audit infrastructure changes |
| **Environment Inconsistency** | 🟡 Medium | "Works in dev, breaks in production" |
| **No Peer Review** | 🟡 Medium | Infrastructure changes bypass code review processes |
| **Slow Replication** | 🟠 Medium | Reproducing a setup takes 30–45 minutes of manual clicking |

### The Core Problem
> *"If your infrastructure isn't in code, it isn't under control."*

> **Speaker Notes:** "The fundamental problem we are solving is this: when organizations manage cloud infrastructure by clicking through the AWS Console manually—what we call ClickOps—they face six critical challenges. Configuration drift means no one knows the true state. Human error leads to security vulnerabilities. And without version control, there's no way to review or roll back changes. Our project eliminates all of these issues."

---

## SLIDE 4: OBJECTIVES

### What We Set Out to Achieve

✅ **Zero ClickOps** — 100% of cloud resources provisioned via declarative HCL code

✅ **Modular Architecture** — Three decoupled child modules: `networking`, `compute`, `storage`

✅ **Network Isolation** — VPC with public-private subnet segmentation

✅ **Automated Web Server** — Nginx bootstrapped on EC2 startup via unattended user-data script

✅ **Zero-Trust Storage** — S3 with AES-256 encryption, versioning, public access blocked

✅ **Least-Privilege Security** — Deployed via dedicated IAM user, not root account

✅ **Clean Lifecycle** — Create, verify, and destroy with single commands

> **Speaker Notes:** "Our project had seven clear engineering objectives. The most important principle was 'zero ClickOps'—we never touched the AWS Console to create or modify any resource. Everything was defined in code, reviewed in Git, and applied through Terraform."

---

## SLIDE 5: BACKGROUND — IaC & TERRAFORM

### Imperative vs. Declarative Infrastructure

| Aspect | Imperative (AWS CLI, Ansible) | Declarative (Terraform) |
|--------|------|------|
| Approach | Step-by-step commands | Define desired end state |
| Ordering | Engineer specifies order | Terraform calculates DAG |
| Drift Detection | Manual | Automated via `terraform plan` |
| Idempotency | Must be engineered | Built-in |

### Why Terraform?

| Criterion | Terraform | CloudFormation | Ansible |
|-----------|-----------|----------------|---------|
| Multi-Cloud | ✅ AWS, Azure, GCP | ❌ AWS only | ⚠️ Limited |
| Language | HCL (purpose-built) | JSON/YAML | YAML |
| State Management | Built-in | AWS-managed | None |
| Industry Adoption | #1 globally | AWS-centric | Config management |

> **Speaker Notes:** "Terraform uses a declarative approach. Instead of writing step-by-step scripts, we define what our infrastructure should look like, and Terraform figures out how to get there. It builds a Directed Acyclic Graph—or DAG—to determine the correct creation order. We chose Terraform over CloudFormation because Terraform skills are cloud-agnostic and transfer to Azure, GCP, and 3,000+ other providers."

---

## SLIDE 6: SYSTEM ARCHITECTURE

### AWS Multi-Tier Architecture (ap-south-1 — Mumbai)

```
+─────────────────────────────────────────────────────────────+
│                      VPC (10.0.0.0/16)                     │
│                                                             │
│  ┌────────────────────────┐   ┌────────────────────────┐   │
│  │ PUBLIC SUBNET          │   │ PRIVATE SUBNET         │   │
│  │ CIDR: 10.0.1.0/24     │   │ CIDR: 10.0.2.0/24     │   │
│  │                        │   │                        │   │
│  │  ┌──────────────────┐  │   │  Reserved for:         │   │
│  │  │ EC2 (t3.micro)   │  │   │  • RDS Database        │   │
│  │  │ Nginx (Port 80)  │  │   │  • Internal APIs       │   │
│  │  │ Elastic IP       │  │   │  • Backend Workers     │   │
│  │  └──────────────────┘  │   │                        │   │
│  │                        │   │  No Internet Access    │   │
│  │  Security Group:       │   │                        │   │
│  │  HTTP(80) HTTPS(443)   │   └────────────────────────┘   │
│  │  SSH(22) All Outbound  │                                │
│  └───────────┬────────────┘                                │
│              ▼                                              │
│     Internet Gateway (IGW) ──── Route: 0.0.0.0/0 → IGW    │
└──────────────┬──────────────────────────────────────────────┘
               ▼
      [ Public Internet ]

┌─────────────────────────────────────────────────────────────┐
│           S3 Storage Bucket (Encrypted)                     │
│  AES-256 SSE │ Versioning: ON │ Public Access: BLOCKED     │
└─────────────────────────────────────────────────────────────┘
```

> **Speaker Notes:** "This is our complete architecture. We have a VPC with a 10.0.0.0/16 CIDR block providing 65,536 IP addresses. Inside the VPC, we created two subnets: a public subnet hosting our EC2 web server with Nginx, and a private subnet reserved for future database or backend services. The public subnet has a route table pointing to an Internet Gateway for internet access. The private subnet intentionally has no internet route, demonstrating proper network isolation. Below that, we have an S3 bucket with three layers of security: AES-256 encryption, versioning, and a complete public access block."

---

## SLIDE 7: AWS SERVICES BREAKDOWN

### Services Used and Their Roles

| Service | Role in Architecture | Key Configuration |
|---------|---------------------|-------------------|
| **Amazon VPC** | Network boundary & isolation | CIDR `10.0.0.0/16`, DNS hostnames enabled |
| **Subnets (×2)** | Public/private tier segmentation | Public: `10.0.1.0/24`, Private: `10.0.2.0/24` |
| **Internet Gateway** | VPC ↔ Internet bridge | Attached to VPC, referenced in route table |
| **Route Table** | Traffic routing rules | `0.0.0.0/0` → IGW for public subnet only |
| **Security Group** | Stateful instance firewall | Inbound: HTTP (80), HTTPS (443), SSH (22) |
| **EC2 Instance** | Compute (web server) | `t3.micro`, Amazon Linux 2023, user-data |
| **Elastic IP** | Static public IPv4 | Persists across instance stop/start cycles |
| **Amazon S3** | Encrypted object storage | AES-256 SSE, versioning, public access block |
| **IAM** | Least-privilege access | `terraform-admin` user (not root) |

**Total AWS Resources Managed:** 15

> **Speaker Notes:** "We used 9 different AWS services to build this architecture, resulting in 15 total managed resources. Each service was selected to fulfill a specific operational requirement. Importantly, everything stays within AWS Free Tier limits—the total project cost was zero dollars."

---

## SLIDE 8: MODULAR CODE STRUCTURE

### Industry-Standard Repository Layout

```
terraform-aws-iac/
├── modules/                        ← Reusable building blocks
│   ├── networking/                  ← VPC, Subnets, IGW, Routes, SG
│   │   ├── main.tf       (118 lines)
│   │   ├── variables.tf  (36 lines)
│   │   └── outputs.tf    (20 lines)
│   │
│   ├── compute/                     ← EC2, EIP, User Data
│   │   ├── main.tf       (49 lines)
│   │   ├── variables.tf  (28 lines)
│   │   ├── outputs.tf    (15 lines)
│   │   └── user_data.sh  (151 lines)
│   │
│   └── storage/                     ← S3, Encryption, Public Block
│       ├── main.tf       (46 lines)
│       ├── variables.tf  (18 lines)
│       └── outputs.tf    (15 lines)
│
└── environments/
    └── dev/                         ← Root module (environment config)
        ├── main.tf                  ← Calls all 3 child modules
        ├── variables.tf             ← Environment-specific parameters
        ├── outputs.tf               ← Aggregated outputs
        ├── providers.tf             ← AWS provider + default tags
        └── versions.tf              ← Version constraints
```

### Why Modules?

- **Reusability:** Same modules, different environment parameters
- **Encapsulation:** Each module is a black box with clean inputs/outputs
- **DRY Principle:** Write once, deploy to dev/staging/prod

> **Speaker Notes:** "We followed the industry-standard Terraform module pattern. Our code is organized into three self-contained modules: networking, compute, and storage. Each module has its own main.tf for resources, variables.tf for inputs, and outputs.tf for exported values. The environments/dev directory acts as the root module that wires everything together. This pattern means we can create a staging or production environment simply by creating a new directory and calling the same modules with different parameters."

---

## SLIDE 9: TERRAFORM WORKFLOW & EXECUTION

### Core Lifecycle Commands

```
  terraform init        Download providers, initialize modules
       ↓
  terraform fmt         Format code to HashiCorp style
       ↓
  terraform validate    Check syntax and internal consistency
       ↓                            Result: "Success!"
  terraform plan        Preview changes (dry run)
       ↓                            Result: "15 to add"
  terraform apply       Execute the plan in AWS
       ↓                            Result: "15 added, 0 destroyed"
  terraform destroy     Delete all managed resources
                                    Result: "15 destroyed"
```

### Dependency Resolution (DAG)

Terraform automatically determines creation order:
1. VPC must exist before Subnets
2. Subnets must exist before EC2 Instance
3. Security Group must exist before EC2 Instance
4. EC2 must exist before EIP Association
5. S3 Bucket must exist before Versioning/Encryption configs

> **Speaker Notes:** "Terraform follows a five-command workflow. First, `init` downloads the AWS provider plugin. Then `validate` checks our syntax. The critical step is `plan`—this is a dry run that shows exactly what Terraform will create, modify, or destroy before touching any real resources. Only after reviewing the plan do we run `apply`. Terraform builds a Directed Acyclic Graph to determine the correct creation order. It knows the VPC must exist before subnets, and subnets must exist before EC2 instances. This dependency resolution is fully automatic."

---

## SLIDE 10: COMPUTE AUTOMATION — USER DATA

### EC2 Bootstrapping (Zero SSH Required)

The `user_data.sh` script runs automatically on first boot:

```bash
#!/bin/bash
exec > /var/log/user-data.log 2>&1      # Log everything for debugging

dnf update -y                            # Update system packages
dnf install -y nginx                     # Install Nginx web server

# Generate custom HTML landing page with:
# - Glassmorphism design (modern CSS)
# - Project branding badges
# - Infrastructure tier descriptions
cat <<'EOF' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<!-- 151-line responsive landing page -->
EOF

systemctl start nginx                    # Start Nginx
systemctl enable nginx                   # Enable on reboot
```

### Key Design Decisions
- **Dual package manager:** `dnf || yum` for AL2023 + AL2 compatibility
- **Full logging:** Output redirected to `/var/log/user-data.log`
- **Auto-start on reboot:** `systemctl enable` ensures Nginx survives restarts

> **Speaker Notes:** "One of the most powerful features of our project is compute automation. When the EC2 instance launches, it runs a user-data shell script that updates packages, installs Nginx, generates a custom HTML landing page with modern CSS design, and starts the web server—all without any manual SSH connection. We also redirect all script output to a log file for debugging, and use systemctl enable to ensure Nginx restarts automatically if the instance reboots."

---

## SLIDE 11: SECURITY CONTROLS

### Defense in Depth — 4 Security Layers

| Layer | Implementation | Purpose |
|-------|---------------|---------|
| **1. IAM** | Dedicated `terraform-admin` user | No root account CLI access |
| **2. Network** | Security Group with explicit port rules | Only HTTP, HTTPS, SSH allowed inbound |
| **3. Storage** | S3 public access block (all 4 settings) | Zero public exposure on objects |
| **4. Encryption** | AES-256 server-side encryption | Data protected at rest |

### Additional Protections

| Control | Details |
|---------|---------|
| Git Security | `.tfstate`, `.tfvars`, AWS credentials excluded via `.gitignore` |
| Subnet Isolation | Private subnet has no internet route — isolated by default |
| S3 Versioning | Object revision history preserved — rollback capable |
| Default Tags | `ManagedBy = "Terraform"` on every resource for auditing |

> **Speaker Notes:** "Security was embedded from day zero, not added as an afterthought. We implemented four layers of security. First, we used a dedicated IAM user for Terraform CLI operations—never the root account. Second, our Security Group acts as a stateful firewall allowing only specific ports. Third, our S3 bucket has all four public access block settings enabled, making it impossible to accidentally expose stored objects. Fourth, AES-256 encryption protects all data at rest. We also used .gitignore to ensure no secrets, state files, or credentials ever get committed to GitHub."

---

## SLIDE 12: LIVE RESULTS & VERIFICATION

### Real `terraform apply` Outputs

```hcl
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

### Web Server Verification

```bash
$ curl -I http://13.204.131.183
HTTP/1.1 200 OK
Server: nginx/1.26.2
Content-Type: text/html
```

### Verification Checklist
- ✅ `terraform validate` — 0 errors
- ✅ `terraform plan` — 15 resources planned
- ✅ `terraform apply` — 15 resources created
- ✅ Browser test — HTTP 200 OK with custom landing page
- ✅ `terraform destroy` — 15 resources cleanly removed

> **Speaker Notes:** "Here are our actual live results. Terraform successfully created all 15 resources in the ap-south-1 Mumbai region. The key output is the Elastic IP—13.204.131.183—which we verified by running curl against it, receiving an HTTP 200 OK response with our custom Nginx landing page. We also verified every resource in the AWS Console. Finally, terraform destroy cleanly removed all 15 resources, confirming zero orphaned resources and zero unexpected charges."

---

## SLIDE 13: ADVANTAGES & COMPARATIVE ANALYSIS

### ClickOps vs. Terraform IaC

| Metric | Manual Console (ClickOps) | Terraform IaC (Our Solution) |
|--------|--------------------------|------------------------------|
| **Provisioning Speed** | 30–45 minutes | < 2 minutes |
| **Consistency** | Human error prone | 100% deterministic |
| **Drift Detection** | Not possible | Automated via `terraform plan` |
| **Version Control** | None | Full Git commit history |
| **Peer Review** | None | Pull request workflows |
| **Modularity** | None | Reusable across environments |
| **Teardown Safety** | Risk of orphaned resources | Single `terraform destroy` |
| **Documentation** | Separate wikis | Code IS documentation |
| **Cost Visibility** | After the fact | Before apply via `plan` |
| **Rollback** | Manual recreation | `git revert` + `terraform apply` |

### Key Achievement
> **15 AWS resources provisioned in < 2 minutes with 0 manual steps**

> **Speaker Notes:** "This comparison table captures the core value of Infrastructure as Code. The most striking difference is speed—what takes 30 to 45 minutes of manual clicking takes less than 2 minutes with Terraform. But speed isn't even the biggest win. Consistency, drift detection, version control, and peer review are the real enterprise benefits. And the single-command teardown eliminates the risk of forgotten resources accumulating charges on your AWS bill."

---

## SLIDE 14: FUTURE SCOPE & ROADMAP

### Evolution Path

| Timeline | Enhancement | Impact |
|----------|------------|--------|
| **Short Term** | Remote State Backend (S3 + DynamoDB) | Multi-engineer collaboration with state locking |
| **Short Term** | CI/CD Pipeline (GitHub Actions) | Automated `plan` on PRs, `apply` on merge |
| **Medium Term** | Multi-AZ with ALB | High availability and load distribution |
| **Medium Term** | Auto Scaling Group | Automatic horizontal scaling under load |
| **Medium Term** | HTTPS with ACM | SSL/TLS certificate for secure connections |
| **Long Term** | Container Migration (ECS/EKS) | Containerized workloads with orchestration |
| **Long Term** | Monitoring (CloudWatch + SNS) | Metrics, logs, and alerting |
| **Long Term** | Cost Estimation (Infracost) | Pre-apply cost impact analysis |

### Current Limitations Acknowledged
- Local state file (no multi-engineer support)
- No NAT Gateway (cost constraint — $30/month)
- Single Availability Zone (no HA)
- HTTP only (no TLS/SSL certificate)

> **Speaker Notes:** "We are transparent about our current limitations. The state file is stored locally, we operate in a single availability zone, and we serve over HTTP without TLS. These are deliberate decisions driven by Free Tier cost constraints. In a production environment, the first enhancements would be migrating to a remote S3 state backend with DynamoDB locking, adding a CI/CD pipeline with GitHub Actions, and deploying across multiple availability zones with a load balancer."

---

## SLIDE 15: CONCLUSION & Q&A

### Summary of Achievements

| Deliverable | Status |
|-------------|--------|
| Custom VPC with public-private subnet architecture | ✅ Completed |
| EC2 web server with automated Nginx bootstrapping | ✅ Completed |
| S3 storage with AES-256 encryption & public access block | ✅ Completed |
| 3 reusable Terraform modules (networking, compute, storage) | ✅ Completed |
| 15 AWS resources provisioned in < 2 minutes | ✅ Verified |
| Zero manual console steps required | ✅ Verified |
| Complete infrastructure teardown via single command | ✅ Verified |
| Code published on GitHub with MIT License | ✅ Published |

### Key Takeaway

> *"Infrastructure as Code transforms cloud infrastructure from a manual, error-prone process into an automated, version-controlled, peer-reviewed software engineering practice."*

---

### 🔗 Repository: [github.com/Nakul71/terraform-aws-iac](https://github.com/Nakul71/terraform-aws-iac)

**Thank You! We are now open for your questions.**

> **Speaker Notes:** "In conclusion, our project successfully demonstrates the full lifecycle of Infrastructure as Code on AWS. We designed a modular, multi-tier architecture, implemented it in Terraform, deployed 15 resources in under 2 minutes with zero manual steps, verified it through multiple methods, and cleanly destroyed everything afterward. The code is published on GitHub for review. Thank you for your time and attention. We are happy to answer any questions you may have."

---

## APPENDIX: POTENTIAL VIVA QUESTIONS & ANSWERS

### Q1: What is Infrastructure as Code?
**A:** IaC is the practice of managing cloud infrastructure through machine-readable definition files instead of manual console operations. It enables version control, peer review, and automated deployment of infrastructure.

### Q2: Why Terraform over CloudFormation?
**A:** Terraform is cloud-agnostic (works with AWS, Azure, GCP, and 3,000+ providers), uses purpose-built HCL syntax, and is the industry standard for multi-cloud environments. CloudFormation is limited to AWS only.

### Q3: What is a Terraform state file?
**A:** The state file (`terraform.tfstate`) is a JSON document that maps HCL resource definitions to real AWS resource IDs. It's Terraform's memory of what it has created, enabling drift detection and change planning.

### Q4: Why did you use modules?
**A:** Modules promote code reuse (DRY principle), encapsulation, and separation of concerns. The same networking/compute/storage modules can be called from dev/staging/prod environments with different parameters.

### Q5: What is the difference between a public and private subnet?
**A:** A public subnet has a route table entry directing traffic to an Internet Gateway, enabling direct internet access. A private subnet has no such route, keeping its instances isolated from direct internet exposure.

### Q6: Why use an Elastic IP?
**A:** A default EC2 public IP changes when the instance is stopped and started. An Elastic IP provides a static, persistent public IPv4 address that survives instance lifecycle events.

### Q7: What does `terraform plan` do?
**A:** It performs a dry run—querying AWS APIs and comparing current state against desired state in HCL—then displays exactly what resources will be created, modified, or destroyed, without making any actual changes.

### Q8: Why is your S3 bucket name randomized?
**A:** S3 bucket names must be globally unique across all AWS accounts worldwide. We use a `random_id` resource to generate a unique suffix, preventing naming collisions.

### Q9: What is a Security Group?
**A:** A Security Group is a stateful virtual firewall that controls inbound and outbound traffic at the instance level. "Stateful" means if an inbound request is allowed, the response is automatically allowed outbound.

### Q10: How would you make this production-ready?
**A:** Remote state backend with S3 + DynamoDB locking, CI/CD pipeline with GitHub Actions, multi-AZ deployment with ALB, auto-scaling, HTTPS with ACM certificate, and restricted SSH access via Systems Manager.
