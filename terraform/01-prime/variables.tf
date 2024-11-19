variable "environment_name" {
  description = "The environment name"
  type        = string
  nullable    = false
}

################################################################################
# AWS
################################################################################

variable "aws_cli_profile" {
  description = "The AWS CLI profile name"
  type        = string
  default     = "default"
}

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
