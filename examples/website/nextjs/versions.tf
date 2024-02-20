/**
 * Terraform and Provider versions
 ***/

provider "aws" {
  region = "us-east-2"
}

terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.34"
    }
  }
}
