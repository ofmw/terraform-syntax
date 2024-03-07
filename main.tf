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

#Create Public Subnet
resource "aws_subnet" "pub-sub-a" {
  vpc_id            = aws_vpc.def-vpc.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "tf-pub-sub-a"
  }
}

resource "aws_subnet" "pub-sub-c" {
  vpc_id            = aws_vpc.def-vpc.id
  cidr_block        = "10.10.12.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "tf-pub-sub-c"
  }
}

# #Create Private Subnet
# resource "aws_subnet" "pvt-sub-a" {
#   vpc_id            = aws_vpc.def-vpc.id
#   cidr_block        = "10.10.13.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "tf-pvt-sub-a"
#   }
# }

# resource "aws_subnet" "pvt-sub-c" {
#   vpc_id            = aws_vpc.def-vpc.id
#   cidr_block        = "10.10.14.0/24"
#   availability_zone = "us-east-1c"
#   tags = {
#     Name = "tf-pvt-sub-c"
#   }
# }
