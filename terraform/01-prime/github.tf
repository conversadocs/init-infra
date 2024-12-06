data "github_repository" "init_infra" {
  full_name = "conversadocs/init-infra"
}

data "github_repository" "landing_zone_infra" {
  full_name = "conversadocs/landing_zone-infra"
}

################################################################################
# CloudQ
################################################################################

resource "github_team" "cloudq" {
  name        = "CloudQ"
  description = "Outside Contributors from CloudQ"
}

resource "github_team_repository" "cloudq_init_infra" {
  team_id    = github_team.cloudq.id
  repository = data.github_repository.init_infra.name
  permission = "push"
}

resource "github_team_repository" "cloudq_landing_zone_infra" {
  team_id    = github_team.cloudq.id
  repository = data.github_repository.landing_zone_infra.name
  permission = "push"
}
