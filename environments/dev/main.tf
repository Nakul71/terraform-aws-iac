# Data source to dynamically get available AZs in current region
data "aws_availability_zones" "available" {
  state = "available"
}

# 1. Networking Module (VPC, Subnets, IGW, Route Tables, Security Group)
module "networking" {
  source = "../../modules/networking"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = data.aws_availability_zones.available.names[0]
  environment         = var.environment
  project_name        = var.project_name
}

# 2. Compute Module (EC2 Instance + Nginx + Elastic IP)
module "compute" {
  source = "../../modules/compute"

  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.networking.web_security_group_id
  instance_type     = var.instance_type
  environment       = var.environment
  project_name      = var.project_name
}

# 3. Storage Module (S3 Bucket + Versioning + Encryption + Public Access Block)
module "storage" {
  source = "../../modules/storage"

  bucket_prefix = var.s3_bucket_prefix
  environment   = var.environment
  project_name  = var.project_name
}
