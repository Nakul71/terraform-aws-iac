variable "subnet_id" {
  description = "Public Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to attach to the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type (Free Tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name tag"
  type        = string
  default     = "terraform-aws-iac"
}
