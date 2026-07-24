resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 1. S3 Bucket
resource "aws_s3_bucket" "storage" {
  bucket        = "${var.bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"
  force_destroy = true # Safe cleanup during terraform destroy

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
