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

variable "names" {
  type    = list(string)
  default = ["son", "park"]
}

module "personal-custom-vpc" {
  # for_each  = toset(var.names)
  for_each  = toset([for s in var.names : "${s}-test"])
  source    = "./custom_vpc"
  team-name = "personal-${each.key}"
}

output "vpc-id" {
  value = [for vpc in module.personal-custom-vpc : vpc.vpc_id]
}
