
terraform = softwareSystem "terraform" {
    description "./terraform"
    tags "ConversaDocs - Terraform"

    cicd = container "cicd" {
        description "/modules/cicd"
        tags "ConversaDocs - Terraform"

        permissions_boundary = component "permissions_boundary" {
        description "aws_iam_policy"
        tags "Amazon Web Services - AWS Identity Access Management Permissions"
        }

        cicd_assume_role_policy = component "cicd_assume_role_policy" {
        description "aws_iam_policy_document"
        tags "Amazon Web Services - AWS Identity Access Management Role"
        }

        cicd_role = component "cicd_role" {
        description "aws_iam_role"
        tags "Amazon Web Services - AWS Identity Access Management Role"

        -> permissions_boundary "" "" ""
        -> cicd_assume_role_policy "" "" ""
        }

        cicd_role_policy_attach = component "cicd_role_policy_attach" {
        description "aws_iam_role_policy_attachment"
        tags "Amazon Web Services - AWS Identity Access Management Role"

        -> cicd_role "" "" ""
        -> permissions_boundary "" "" ""
        }

        cicd_user = component "cicd_user" {
        description "aws_iam_user"
        tags "Amazon Web Services - AWS Identity Access Management Long Term Security Credential"

        -> permissions_boundary "" "" ""
        }

        cicd_group = component "cicd_group" {
        description "aws_iam_group"
        tags "Amazon Web Services - AWS Identity Access Management Temporary Security Credential"
        }

        cicd_user_group_membership = component "cicd_user_group_membership" {
        description "aws_iam_user_group_membership"
        tags "Amazon Web Services - AWS Identity Access Management Temporary Security Credential"

        -> cicd_user "" "" ""
        -> cicd_group "" "" ""
        }

        cicd_group_policy_attach = component "cicd_group_policy_attach" {
        description "aws_iam_group_policy_attachment"
        tags "Amazon Web Services - AWS Identity Access Management Role"

        -> cicd_group "" "" ""
        -> permissions_boundary "" "" ""
        }

        cicd_user_key = component "cicd_user_key" {
        description "aws_iam_access_key"
        tags "Amazon Web Services - AWS Identity Access Management Add on"

        -> cicd_user "" "" ""
        }

        aws_access_key_id = component "aws_access_key_id" {
        description "github_actions_organization_secret"
        tags "ConversaDocs - GitHub Organization Secret"

        -> cicd_user_key "" "" ""
        }

        aws_secret_access_key = component "aws_secret_access_key" {
        description "github_actions_organization_secret"
        tags "ConversaDocs - GitHub Organization Secret"

        -> cicd_user_key "" "" ""
        }
    }

    prime = container "prime" {
        description "/01-prime"
        tags "ConversaDocs - Terraform"

        -> cicd "" "" ""

        aws_organization = component "this" {
        description "aws_organizations_organization"
        tags "Amazon Web Services - Organizations"
        }

        deny_unused_services = component "deny_unused_services" {
        description "aws_organizations_policy"
        tags "Amazon Web Services - AWS Identity Access Management Permissions"
        }

        dev_ou = component "dev_ou" {
        description "aws_organizations_organizational_unit"
        tags "Amazon Web Services - AWS Organizations Organizational Unit"

        -> aws_organization "" "" ""
        }

        dev_account = component "dev_account" {
        description "aws_organizations_account"
        tags "Amazon Web Services - AWS Organizations Account"

        -> dev_ou "" "" ""
        }

        dev_scp_attachment = component "dev_scp_attachment" {
        description "aws_organizations_policy_attachment"
        tags "Amazon Web Services - AWS Identity Access Management Permissions"

        -> deny_unused_services "" "" ""
        -> dev_ou "" "" ""
        }
    }
}