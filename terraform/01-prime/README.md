# 01-prime

This is the initial prime AWS account that acts as the control center for all others.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.76.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.76.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cicd"></a> [cicd](#module\_cicd) | ../modules/cicd | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_account.dev_account](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/organizations_account) | resource |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.dev_ou](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.deny_unused_services](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.dev_scp_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/organizations_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cli_profile"></a> [aws\_cli\_profile](#input\_aws\_cli\_profile) | The AWS CLI profile name | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"us-east-1"` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The environment name | `string` | n/a | yes |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | The Github org name | `string` | `"conversadocs"` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | The access token for Github | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | n/a |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | n/a |
<!-- END_TF_DOCS -->
