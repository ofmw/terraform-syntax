terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1" #버전은 직접 명시하는게 좋다.
    }
  }
  backend "s3" {
    bucket = "tf-backend-01-202403081122"
    key    = "terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "tf-lock"
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

# variable "envs" {
#   type    = list(string)
#   default = ["dev", "prd", ""]
# }

# module "vpc-list" {
#   # for_each  = toset(var.names)
#   for_each  = toset([for s in var.envs : s if s != ""])
#   source    = "./custom_vpc"
#   team-name = each.key
# }

module "main-vpc" {
  source    = "./custom_vpc"
  team-name = terraform.workspace
}

# output "vpc-id" {
#   value = [for vpc in module.vpc-list : vpc.vpcId]
# }

# Create S3 Bucket
resource "aws_s3_bucket" "tf-backend" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = "tf-backend-01-202403081122"
  tags = {
    Name = "tf-backend-01"
  }
}

# Create S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "tf-backend-own" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf-backend[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Set S3 Bucket ACL
resource "aws_s3_bucket_acl" "tf-backend-acl" {
  count      = terraform.workspace == "default" ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.tf-backend-own]
  bucket     = aws_s3_bucket.tf-backend[0].id
  acl        = "private"
}

# Set S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "tf-backend-ver" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf-backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# # Set DynamoDB Table
# resource "aws_dynamodb_table" "tf-backend-dtb" {
#   name         = "tf-lock"
#   hash_key     = "LockID"
#   billing_mode = "PAY_PER_REQUEST"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# resource "aws_eip" "eip-test" {
#   provisioner "local-exec" {
#     command = "echo ${aws_eip.eip-test.public_ip}"
#   }
#   tags = {
#     Name = "eip-test-01"
#   }
# }

# output "eip-ip" {
#   value = aws_eip.eip-test.public_ip
# }

# resource "aws_instance" "tf-ec2-01" {
#   ami           = "ami-07d9b9ddc6cd8dd30"
#   instance_type = "t2.micro"
#   key_name      = "my-ec2-01"
#   tags = {
#     Name = "tf-ec2-01"
#   }
#   connection {
#     host        = self.public_ip
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("~/Downloads/my-ec2-01.pem")
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update",
#       "sudo apt install -y nginx",
#       "sudo systemctl start nginx"
#     ]
#   }
#   # provisioner "local-exec" {
#   #   command = "echo ${self.public_ip}"
#   # }
# }

# output "tf-ec2-01-ip" {
#   value = aws_instance.tf-ec2-01.public_ip
# }
