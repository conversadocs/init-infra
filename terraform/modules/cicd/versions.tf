terraform {
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
