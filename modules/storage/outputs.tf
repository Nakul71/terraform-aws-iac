output "bucket_id" {
  description = "Name (ID) of the created S3 bucket"
  value       = aws_s3_bucket.storage.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.storage.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = aws_s3_bucket.storage.bucket_regional_domain_name
}
