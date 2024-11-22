################################################################################
# IAM - Policy
################################################################################

resource "aws_iam_policy" "permissions_boundary" {
  name        = "ConversaDocsCicdPermissionsBoundary"
  description = "Permissions boundary for DevOps and CI/CD"

  policy = file("${path.module}/permission_boundary.json")
}

data "aws_iam_policy_document" "cicd_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.cicd_user.arn]
    }

    actions = ["sts:AssumeRole"]
  }
}

################################################################################
# IAM - Role
################################################################################

resource "aws_iam_role" "cicd_role" {
  name               = "ConversaDocsCicdRole"
  assume_role_policy = data.aws_iam_policy_document.cicd_assume_role_policy.json

  permissions_boundary = aws_iam_policy.permissions_boundary.arn
}

resource "aws_iam_role_policy_attachment" "cicd_role_policy_attach" {
  role       = aws_iam_role.cicd_role.name
  policy_arn = aws_iam_policy.permissions_boundary.arn
}

################################################################################
# IAM - Users and Groups
################################################################################

resource "aws_iam_user" "cicd_user" {
  name = "conversadocs-cicd-user"

  permissions_boundary = aws_iam_policy.permissions_boundary.arn
}

resource "aws_iam_group" "cicd_group" {
  name = "ConversaDocsCicdGroup"
}

resource "aws_iam_user_group_membership" "cicd_user_group_membership" {
  user = aws_iam_user.cicd_user.name
  groups = [
    aws_iam_group.cicd_group.name
  ]
}

resource "aws_iam_group_policy_attachment" "cicd_group_policy_attach" {
  group      = aws_iam_group.cicd_group.name
  policy_arn = aws_iam_policy.permissions_boundary.arn
}

resource "aws_iam_access_key" "cicd_user_key" {
  user = aws_iam_user.cicd_user.name
}

################################################################################
# Github
################################################################################

resource "github_actions_organization_secret" "aws_access_key_id" {
  secret_name     = "${upper(var.environment_name)}_AWS_ACCESS_KEY_ID"
  visibility      = "private"
  plaintext_value = aws_iam_access_key.cicd_user_key.id
}

resource "github_actions_organization_secret" "aws_secret_access_key" {
  secret_name     = "${upper(var.environment_name)}_AWS_SECRET_ACCESS_KEY"
  visibility      = "private"
  plaintext_value = aws_iam_access_key.cicd_user_key.secret
}

################################################################################
# Output
################################################################################

output "access_key_id" {
  value     = aws_iam_access_key.cicd_user_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.cicd_user_key.secret
  sensitive = true
}
