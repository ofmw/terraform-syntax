terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1" #버전은 직접 명시하는게 좋다.
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Module
# #DEV
# module "def-custom-vpc" {
#   source    = "./custom_vpc"
#   team-name = "dev"
# }

# #PRD
# module "prd-custom-vpc" {
#   source    = "./custom_vpc"
#   team-name = "prd"
# }

# resource "test_instance" "x" {
#   prd_vpc_id = module.def-custom-vpc.id
#   dev_vpc_id = module.prd-custom-vpc.id
# }

variable "envs" {
  type    = list(string)
  default = ["dev", "prd", ""]
}

module "vpc-list" {
  # for_each  = toset(var.names)
  for_each  = toset([for s in var.envs : s if s != ""])
  source    = "./custom_vpc"
  team-name = each.key
}

output "vpc-id" {
  value = [for vpc in module.vpc-list : vpc.vpcId]
}

# Create S3 Bucket
resource "aws_s3_bucket" "tf-backend" {
  bucket = "tf-backend-01-202403081122"
  tags = {
    Name = "tf-backend-01"
  }
}

# Create S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "tf-backend-own" {
  bucket = aws_s3_bucket.tf-backend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Set S3 Bucket ACL
resource "aws_s3_bucket_acl" "tf-backend-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.tf-backend-own]
  bucket     = aws_s3_bucket.tf-backend.id
  acl        = "private"
}

# Set S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "tf-backend-ver" {
  bucket = aws_s3_bucket.tf-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
