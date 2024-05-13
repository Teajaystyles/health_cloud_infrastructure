terraform {
  backend "s3" {
    bucket = "health-infrastructure-terraform-states"
    key    = "terraform/020-compute"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}

provider "aws" {}
