# cicd

A terraform module to define CI/CD assets for ConversaDocs managed environments.

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
| <a name="provider_github"></a> [github](#provider\_github) | 6.3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.cicd_user_key](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_access_key) | resource |
| [aws_iam_group.cicd_group](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.cicd_group_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.permissions_boundary](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.cicd_role](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cicd_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.cicd_user](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.cicd_user_group_membership](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/resources/iam_user_group_membership) | resource |
| [github_actions_organization_secret.aws_access_key_id](https://registry.terraform.io/providers/integrations/github/6.3.1/docs/resources/actions_organization_secret) | resource |
| [github_actions_organization_secret.aws_secret_access_key](https://registry.terraform.io/providers/integrations/github/6.3.1/docs/resources/actions_organization_secret) | resource |
| [aws_iam_policy_document.cicd_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/5.76.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The environment name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | n/a |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | n/a |
<!-- END_TF_DOCS -->
