output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "ID of the Public Subnet"
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the Private Subnet"
  value       = module.networking.private_subnet_id
}

output "ec2_instance_id" {
  description = "ID of the web server EC2 instance"
  value       = module.compute.instance_id
}

output "ec2_public_ip" {
  description = "Elastic Public IP of the web server"
  value       = module.compute.public_ip
}

output "nginx_web_url" {
  description = "Web URL to access the deployed Nginx application"
  value       = "http://${module.compute.public_ip}"
}

output "s3_bucket_name" {
  description = "Globally unique name of the S3 storage bucket"
  value       = module.storage.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 storage bucket"
  value       = module.storage.bucket_arn
}
