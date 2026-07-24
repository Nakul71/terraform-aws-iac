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
