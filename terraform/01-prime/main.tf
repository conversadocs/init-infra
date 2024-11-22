data "aws_caller_identity" "_" {}

locals {
  aws_account_id = data.aws_caller_identity._.account_id
}

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

resource "aws_organizations_account" "infrastructure" {
  name                       = "Infrastructure"
  email                      = "awsinfrastructure@conversadocs.com"
  iam_user_access_to_billing = "DENY"
}

resource "aws_organizations_account" "shared_services" {
  name                       = "SharedServices"
  email                      = "awssharedservices@conversadocs.com"
  iam_user_access_to_billing = "DENY"
}

resource "aws_organizations_account" "workloads" {
  name                       = "Workloads"
  email                      = "awsworkloads@conversadocs.com"
  iam_user_access_to_billing = "DENY"
}

resource "aws_organizations_account" "sandbox" {
  name                       = "Sandbox"
  email                      = "awssandbox@conversadocs.com"
  iam_user_access_to_billing = "DENY"
}

resource "aws_iam_policy" "external_contributor_policy" {
  name        = "ConversaDocsExternalContributorPolicy"
  description = "Allows administrative actions with restrictions on sensitive operations."

  policy = file("admin_permissions_boundary.json")
}

resource "aws_iam_role" "external_contributor_role" {
  name = "ConversaDocsExternalContributorRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${local.aws_account_id}:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  permissions_boundary = aws_iam_policy.permissions_boundary_policy.arn
}

resource "aws_iam_group" "external_contributor_group" {
  name = "ConversaDocsExternalContributorGroup"
}

resource "aws_iam_group_policy_attachment" "external_contributor_group_policy_attach" {
  group      = aws_iam_group.external_contributor_group.name
  policy_arn = aws_iam_policy.external_contributor_policy.arn
}

resource "aws_iam_role_policy_attachment" "external_contributor_role_attachment" {
  role       = aws_iam_role.external_contributor_role.name
  policy_arn = aws_iam_policy.external_contributor_policy.arn
}

resource "aws_iam_policy" "permissions_boundary_policy" {
  name        = "ConversaDocsExternalContributorPermissionsBoundary"
  description = "Permissions boundary for the external contributor role."

  policy = aws_iam_policy.external_contributor_policy.policy
}

################################################################################
# Billing
################################################################################

resource "aws_budgets_budget" "billing" {
  name              = "conversadocs-billing"
  budget_type       = "COST"
  limit_amount      = "1200"
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2017-07-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["awsbilling@conversadocs.com"]
  }
}

################################################################################
# Config
################################################################################

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config"
  role_arn = aws_iam_role.config_role.arn
}

resource "aws_config_delivery_channel" "config_channel" {
  name           = "config"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
}

resource "aws_iam_role" "config_role" {
  name = "AWSConfigRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "config.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_role_policy" "config_role_policy" {
  name = "AWSConfigPolicy"
  role = aws_iam_role.config_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetBucketAcl"
        ]
        Resource = [
          "${aws_s3_bucket.config_bucket.arn}",
          "${aws_s3_bucket.config_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "config-bucket-${random_id.bucket_id.hex}"
}

resource "aws_s3_bucket_ownership_controls" "config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "config_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.config_bucket]

  bucket = aws_s3_bucket.config_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.aws_s3_config_bucket_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Resource = "${aws_s3_bucket.config_bucket.arn}/*"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = "${aws_s3_bucket.config_bucket.arn}"
      }
    ]
  })
}

resource "random_id" "bucket_id" {
  byte_length = 8
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
