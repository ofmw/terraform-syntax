# Team Name
variable "team-name" {
  type    = string
  default = "def"
}

# Create VPC
resource "aws_vpc" "def-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = format("tf-%s-vpc", var.team-name)
  }
}

# Create Public Subnet
resource "aws_subnet" "pub-sub-a" {
  vpc_id            = aws_vpc.def-vpc.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = format("tf-%s-pub-sub-a", var.team-name)
  }
}

# resource "aws_subnet" "pub-sub-c" {
#   vpc_id            = aws_vpc.def-vpc.id
#   cidr_block        = "10.10.12.0/24"
#   availability_zone = "us-east-1c"
#   tags = {
#     Name = "tf-pub-sub-c"
#   }
# }

# Create Private Subnet
resource "aws_subnet" "pvt-sub-a" {
  vpc_id            = aws_vpc.def-vpc.id
  cidr_block        = "10.10.13.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = format("tf-%s-pvt-sub-a", var.team-name)
  }
}

# resource "aws_subnet" "pvt-sub-c" {
#   vpc_id            = aws_vpc.def-vpc.id
#   cidr_block        = "10.10.14.0/24"
#   availability_zone = "us-east-1c"
#   tags = {
#     Name = "tf-pvt-sub-c"
#   }
# }

#AWS Data
# #Use Subnet ID
# variable "subnet_id" {}

# data "aws_subnet" "selected" {
#   id = "subnet-046be8c7ff308b7e0"
# }

# #Use Tag
# data "aws_subnet" "aws-pvt-sub-a" {
#   filter {
#     name   = "tag:Name"
#     values = ["aws-pvt-sub-a"]
#   }
# }

# Create Internet Gatway
resource "aws_internet_gateway" "def-igw" {
  vpc_id = aws_vpc.def-vpc.id
  tags = {
    Name = format("tf-%s-def-igw", var.team-name)
  }
}

# Create NAT Gatway
resource "aws_nat_gateway" "pvt-ngw-a" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.pub-sub-a.id
  tags = {
    Name = format("tf-%s-pvt-ngw-a", var.team-name)
  }
}
