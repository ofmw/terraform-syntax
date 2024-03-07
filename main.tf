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
#DEV
module "def-custom-vpc" {
  source    = "./custom_vpc"
  team-name = "dev"
}

#PRD
module "prd-custom-vpc" {
  source    = "./custom_vpc"
  team-name = "prd"
}
