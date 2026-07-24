variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name (must be globally unique)"
  type        = string
  default     = "ibm-iac-storage"
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
