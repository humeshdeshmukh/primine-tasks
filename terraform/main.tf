provider "aws" {
  region = var.aws_region
  # Credentials will be sourced from Environment Variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
}

terraform {
  required_version = ">= 1.0.0"
  
  # We will use local state for this playground for simplicity
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
