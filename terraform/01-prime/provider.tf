terraform {
  backend "s3" {
    bucket         = "conversadocs-terraform"
    key            = "state/prime/init.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    profile        = "cd-prime"
  }

  required_version = "1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.3.1"
    }
  }
}

provider "aws" {
  profile = var.aws_cli_profile
  region  = var.aws_region

  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}

provider "github" {
  owner = var.github_organization
  token = var.github_token
}
