terraform {
  backend "s3" {
    bucket = "health-infrastructure-terraform-states"
    key    = "terraform/040-database"
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
