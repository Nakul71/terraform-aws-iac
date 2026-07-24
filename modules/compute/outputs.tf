output "instance_id" {
  description = "ID of the EC2 Instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Elastic Public IP address of the EC2 web server"
  value       = aws_eip.web_eip.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 web server"
  value       = aws_eip.web_eip.public_dns
}
