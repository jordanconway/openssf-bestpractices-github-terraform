locals {
  repo_full_name = "${var.organization}/${var.name}"
}

resource "github_repository" "this" {
  name                   = var.name
  description            = var.description
  homepage_url           = var.homepage_url
  visibility             = var.visibility
  topics                 = var.topics
  has_issues             = var.has_issues
  has_discussions        = var.has_discussions
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  is_template            = var.is_template
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  auto_init              = true
  vulnerability_alerts   = var.vulnerability_alerts
  archived               = false
  # Note: default branch set post creation if needed
}

# Dependabot security updates (enable security fixes)
resource "github_repository_dependabot_security_updates" "this" {
  repository = github_repository.this.name
  enabled    = var.dependabot_security_updates
}

# Secret scanning & push protection
resource "github_repository_security_analysis" "this" {
  repository                      = github_repository.this.name
  secret_scanning                 = var.secret_scanning ? "enabled" : "disabled"
  secret_scanning_push_protection = var.secret_scanning_push_protection ? "enabled" : "disabled"
  advanced_security               = "enabled" # TODO: Parameterize if needed
  dependabot_alerts               = var.vulnerability_alerts ? "enabled" : "disabled"
  code_scanning_default_setup     = "enabled" # TODO: option to disable or customize languages
}

# Branch protection main
resource "github_branch_protection" "main" {
  repository_id  = github_repository.this.node_id
  pattern        = var.default_branch
  enforce_admins = var.enforce_admins

  required_pull_request_reviews {
    dismiss_stale_reviews           = var.dismiss_stale_reviews
    require_code_owner_reviews      = var.require_code_owner_reviews
    required_approving_review_count = var.required_approving_review_count
  }

  required_status_checks {
    strict   = true
    contexts = var.required_status_checks
  }

  allows_deletions                = var.allow_deletions
  allows_force_pushes             = var.allow_force_pushes
  require_signed_commits          = var.require_signed_commits
  required_linear_history         = var.required_linear_history
  require_conversation_resolution = var.require_conversation_resolution
  # Ignore changes to required_status_checks contexts because these may be managed outside of Terraform
  # (e.g., by GitHub Actions or other automation), and enforcing them here can cause unnecessary diffs or errors.
  lifecycle {
    ignore_changes = [required_status_checks[0].contexts]
  }
}

## NOTE: Team/user push restriction configuration intentionally omitted until variables are introduced.

# Simplified Actions permissions (limited support). TODO: expand when provider stabilizes.
resource "github_actions_repository_permissions" "this" {
  repository      = github_repository.this.name
  allowed_actions = var.actions_allowed_actions
}

# CODEOWNERS file (if provided)
resource "github_repository_file" "codeowners" {
  count               = var.codeowners_content == null ? 0 : 1
  repository          = github_repository.this.name
  file                = "CODEOWNERS"
  content             = var.codeowners_content
  commit_message      = "chore: ensure CODEOWNERS present via terraform"
  overwrite_on_create = true
}

# SECURITY.md (security policy)
resource "github_repository_file" "security_md" {
  count               = var.security_policy_content == null ? 0 : 1
  repository          = github_repository.this.name
  file                = ".github/SECURITY.md"
  content             = var.security_policy_content
  commit_message      = "chore: ensure SECURITY.md present via terraform"
  overwrite_on_create = true
}

# Dependabot version updates manifest (basic) - generate dependabot.yml
locals {
  dependabot_yaml = yamlencode({
    version = 2
    updates = [
      for k, v in var.dependabot_updates : {
        "package-ecosystem" = k
        directory           = v.directory
        schedule            = { interval = v.schedule_interval }
      }
    ]
  })
}

# Adjust default branch if not 'main'
resource "github_branch_default" "this" {
  count      = var.default_branch == "main" ? 0 : 1
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_repository_file" "dependabot" {
  count               = length(var.dependabot_updates) == 0 ? 0 : 1
  repository          = github_repository.this.name
  file                = ".github/dependabot.yml"
  content             = local.dependabot_yaml
  commit_message      = "chore: manage dependabot.yml via terraform"
  overwrite_on_create = true
}

