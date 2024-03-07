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

# Create VPC
resource "aws_vpc" "def-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "tf-def-vpc"
  }
}
