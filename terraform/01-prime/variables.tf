variable "environment_name" {
  description = "The environment name"
  type        = string
  default     = "prime"
}

################################################################################
# AWS
################################################################################

variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

################################################################################
# Github
################################################################################

variable "github_organization" {
  description = "The Github org name"
  type        = string
  default     = "conversadocs"
}

variable "github_token" {
  description = "The access token for Github"
  type        = string
  nullable    = false
}
