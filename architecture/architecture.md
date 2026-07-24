# 🏛️ Architecture Documentation

## System Topology Diagram

```
Internet
    │
    ▼
[ Internet Gateway: igw-0682b59d41afe4a4b ]
    │
    ▼
[ Public Route Table: rtb-0d46f521a355944f3 ] ── (0.0.0.0/0 -> IGW)
    │
    ├── Public Subnet (10.0.1.0/24, ap-south-1a)
    │     ├── Security Group (sg-09cb840b6ff0b6f92): Inbound HTTP (80), HTTPS (443), SSH (22)
    │     └── EC2 Instance (i-0528e216ad5723a2b, t3.micro)
    │           └── Elastic IP: 13.204.131.183 (http://13.204.131.183)
    │
    └── Private Subnet (10.0.2.0/24, ap-south-1a)
          └── Isolated Tier (Reserved for database / internal microservices)

[ S3 Bucket: ibm-iac-storage-dev-6efceb8b ]
    ├── Versioning: Enabled
    ├── Server-Side Encryption: AES-256 (SSE-S3)
    └── Public Access Block: All public ACLs & policies blocked
```

## Applied Configuration Details

- **AWS Region:** `ap-south-1` (Mumbai)
- **VPC ID:** `vpc-0f277b1d2c98ef780`
- **VPC CIDR:** `10.0.0.0/16`
- **Managed By:** Terraform IaC (v1.15.8)
