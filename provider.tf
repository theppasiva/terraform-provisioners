terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.43.0"
    }
  }

  backend "s3" {
    bucket = "shivaram-practice-remote-state"
    key    = "provisioner"
    region = "us-east-1"
    dynamodb_table = "shivaram-practice_locking"
  }
}

provider "aws" {
  region = "us-east-1"
}