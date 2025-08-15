resource "github_organization_settings" "this" {
  name                                     = var.organization
  billing_email                            = var.billing_email
  default_repository_permission            = var.default_repository_permission
  members_can_create_public_repositories   = var.members_can_create_public_repositories
  members_can_create_private_repositories  = var.members_can_create_private_repositories
  members_can_create_internal_repositories = var.members_can_create_internal_repositories
  members_can_create_pages                 = var.members_can_create_pages
  members_can_fork_private_repositories    = var.members_can_fork_private_repositories
  web_commit_signoff_required              = var.web_commit_signoff_required

  advanced_security_enabled_for_new_repositories               = var.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.dependabot_alerts_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.secret_scanning_push_protection_enabled_for_new_repositories
}

output "organization" { value = var.organization }
output "id" { value = github_organization_settings.this.id }
