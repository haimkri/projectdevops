terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# קריאה למודול VPC
module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
}

# קריאה למודול EC2
module "ec2" {
  source        = "./modules/ec2"
  environment   = var.environment
  instance_type = var.instance_type
  ami_id        = var.ami_id
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
}

# קריאה למודול S3
module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  bucket_name = var.bucket_name
}