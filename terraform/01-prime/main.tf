################################################################################
# AWS Organizations
################################################################################

resource "aws_organizations_organization" "this" {
  feature_set          = "ALL"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}

resource "aws_organizations_organizational_unit" "dev_ou" {
  name      = "Development"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_account" "dev_account" {
  name      = "DevelopmentAccount"
  email     = "awsdev@conversadocs.com"
  parent_id = aws_organizations_organizational_unit.dev_ou.id
}

resource "aws_organizations_policy" "deny_unused_services" {
  name        = "DenyUnusedServices"
  description = "Deny access to unused AWS services"
  content     = file("scp.json")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "dev_scp_attachment" {
  policy_id = aws_organizations_policy.deny_unused_services.id
  target_id = aws_organizations_organizational_unit.dev_ou.id
}

################################################################################
# Support Resources
################################################################################

module "cicd" {
  source = "../modules/cicd"

  environment_name = "prime"
}

resource "aws_organizations_account" "security" {
  name                       = "Security"
  email                      = "awssecurity@conversadocs.com"
  iam_user_access_to_billing = "ALLOW"
}

################################################################################
# Output
################################################################################

output "access_key_id" {
  value     = module.cicd.access_key_id
  sensitive = true
}

output "secret_access_key" {
  value     = module.cicd.secret_access_key
  sensitive = true
}
