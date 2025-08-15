terraform {
  required_version = ">= 1.6.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}

provider "github" {
  owner = var.organization
  # token is sourced from GITHUB_TOKEN env variable
}

module "test_repo" {
  source                  = "../../modules/repo_hardening"
  organization            = var.organization
  name                    = var.repo_name
  description             = "Example hardened repo managed by Terraform"
  default_branch          = "main"
  topics                  = ["security", "openssf", "terraform"]
  required_status_checks  = ["build", "test"]
  codeowners_content      = <<EOT
* @${var.default_code_owner}
EOT
  security_policy_content = <<EOT
# Security Policy

Report vulnerabilities via GitHub Security Advisories.
EOT
  dependabot_updates = {
    github-actions = { directory = "/", schedule_interval = "weekly" },
    npm            = { directory = "/", schedule_interval = "weekly" }
  }
}
