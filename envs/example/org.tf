module "org" {
  source        = "../../modules/org_hardening"
  organization  = var.organization
  billing_email = "billing@example.com"

  members_can_create_public_repositories   = false
  members_can_create_private_repositories  = false
  members_can_create_internal_repositories = false
  members_can_create_pages                 = false
  members_can_fork_private_repositories    = false

  web_commit_signoff_required = true

  advanced_security_enabled_for_new_repositories               = true
  dependabot_alerts_enabled_for_new_repositories               = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true
}
