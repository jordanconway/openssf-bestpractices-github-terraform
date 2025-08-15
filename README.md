# OpenSSF GitHub Best Practices Terraform

Infrastructure-as-Code to apply a wide subset of OpenSSF SCM Best Practices to GitHub organizations and repositories.

References: https://best.openssf.org/SCM-BestPractices/github/

## Goals

Automate enforceable settings covering:

* Branch protection (status checks, reviews, linear history, force-push & deletion restrictions)
* Security & analysis (secret scanning, dependabot alerts, code scanning default setup, vulnerability alerts)
* Repository hygiene (topics, description, license, default branch, merge strategies)
* Issue & discussion settings (if enabled)
* PR review rules (required reviewers, dismissal restrictions, stale review handling)
* Dependabot version updates (optional)
* Actions security (allowed actions, required approvals for reusable workflows)
* Security policy & code of conduct file presence

## Structure

```
modules/
  repo_hardening/       # Module for per-repository configuration & protections
envs/
  example/              # Example root usage calling the module
```

## Module Inputs

### `repo_hardening` Module Variables

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| organization | string | n/a | Yes | GitHub organization name owning the repository. |
| name | string | n/a | Yes | Repository name to create / manage. |
| description | string | null | No | Repository description. |
| homepage_url | string | null | No | Optional homepage URL. |
| visibility | string (public/private/internal) | "public" | No | Repository visibility. |
| topics | list(string) | [] | No | Repository topics list. |
| has_issues | bool | true | No | Enable Issues. |
| has_discussions | bool | false | No | Enable Discussions. |
| has_projects | bool | false | No | Enable (classic) Projects. |
| has_wiki | bool | false | No | Enable Wiki. |
| is_template | bool | false | No | Mark repository as a template. |
| allow_merge_commit | bool | false | No | Allow merge commits. |
| allow_squash_merge | bool | true | No | Allow squash merges. |
| allow_rebase_merge | bool | false | No | Allow rebase merges. |
| delete_branch_on_merge | bool | true | No | Auto-delete merged branches. |
| enforce_admins | bool | true | No | Apply branch protection to admins. |
| required_approving_review_count | number | 2 | No | Number of required PR approvals. |
| require_code_owner_reviews | bool | true | No | Require CODEOWNERS approval. |
| dismiss_stale_reviews | bool | true | No | Dismiss approvals on new commits. |
| require_signed_commits | bool | true | No | Enforce signed commits on protected branch. |
| required_linear_history | bool | true | No | Enforce linear history. |
| require_conversation_resolution | bool | true | No | Require all review threads resolved. |
| allow_force_pushes | bool | false | No | Permit force pushes (should remain false). |
| allow_deletions | bool | false | No | Permit branch deletion (should remain false). |
| required_status_checks | list(string) | [] | No | Status check contexts required before merge. |
| secret_scanning | bool | true | No | Enable Secret Scanning. |
| secret_scanning_push_protection | bool | true | No | Enable push protection for secrets. |
| dependabot_security_updates | bool | true | No | Enable Dependabot security updates. |
| vulnerability_alerts | bool | true | No | Enable vulnerability alerts (Dependabot alerts). |
| actions_allowed_actions | string (all, local_only) | "all" | No | Coarse Actions policy (fine-grained planned). |
| codeowners_content | string | null | No | Content for CODEOWNERS file (enables owner review rule). |
| security_policy_content | string | null | No | Content for SECURITY.md file. |
| dependabot_updates | map(object({ directory=string, schedule_interval=string })) | {} | No | Version update ecosystems (e.g. `{ npm = { directory = "/" schedule_interval = "weekly" } }`). |
| default_branch | string | "main" | No | Default branch name. |

Outputs:

* `id` – Numeric ID of the created repository.
* `repository_full_name` – Fully qualified `org/name`.

### `org_hardening` Module Variables

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| organization | string | n/a | Yes | GitHub organization name being managed. |
| default_repository_permission | string (none/read/write/admin) | "read" | No | Base permission granted to org members. |
| billing_email | string | "billing@example.com" | No* | Required by API; override with a valid billing email (*treat as required in real usage*). |
| members_can_create_public_repositories | bool | false | No | Allow members to create public repos. |
| members_can_create_private_repositories | bool | false | No | Allow members to create private repos. |
| members_can_create_internal_repositories | bool | false | No | Allow members to create internal repos. |
| members_can_create_pages | bool | false | No | Allow members to publish GitHub Pages. |
| members_can_fork_private_repositories | bool | false | No | Allow forking private repos. |
| web_commit_signoff_required | bool | true | No | Require sign-off on web commits. |
| advanced_security_enabled_for_new_repositories | bool | true | No | Enable GitHub Advanced Security by default. |
| dependabot_alerts_enabled_for_new_repositories | bool | true | No | Enable Dependabot alerts by default. |
| secret_scanning_enabled_for_new_repositories | bool | true | No | Enable secret scanning by default. |
| secret_scanning_push_protection_enabled_for_new_repositories | bool | true | No | Enable push protection for new repos. |

Outputs:

* `organization_id` – Numeric ID of the organization.

### Required vs Optional Summary
Minimal invocation:
* `repo_hardening`: `organization`, `name` (all other inputs inherit secure defaults).
* `org_hardening`: `organization`, and you should override `billing_email` with a real address.

Security-impacting toggles default to the most secure practical value (e.g. secret scanning enabled, force pushes disabled) so you only override to relax (not to harden) in most cases.

## Quick Start

1. Create a GitHub App or PAT with required scopes (repo, admin:repo_hook, security_events, workflow, read:org, admin:org optional)
2. Export credentials (recommend using a TF Cloud/Workspace secret or environment variable `GITHUB_TOKEN`).
3. Adjust `envs/example/terraform.tfvars` to point at your org & repos.
4. Init & apply.

```
terraform -chdir=envs/example init
terraform -chdir=envs/example plan
terraform -chdir=envs/example apply
```

## Usage Examples

### Minimal Repository Hardening

Create a single hardened repository with only required inputs (secure defaults apply):

```hcl
module "repo_min" {
  source       = "../modules/repo_hardening"
  organization = var.organization
  name         = "sample-app"
}
```

### Repository With CODEOWNERS, SECURITY.md And Dependabot Version Updates

```hcl
module "repo_full" {
  source       = "../modules/repo_hardening"
  organization = var.organization
  name         = "payments-service"
  description  = "Service handling payment orchestration"
  visibility   = "private"

  topics       = ["payments", "service", "golang"]

  required_status_checks = [
    "build",            # CI pipeline
    "unit-tests",       # Test suite
    "codeql"            # CodeQL default setup
  ]

  dependabot_updates = {
    npm = {
      directory         = "/"
      schedule_interval = "weekly"
    }
    github_actions = {
      directory         = "/"
      schedule_interval = "daily"
    }
  }

  codeowners_content = <<-EOT
    # Global owners
    *       @org/platform-team
    /infra/ @org/devops-team
  EOT

  security_policy_content = <<-EOT
    # Security Policy
    Please report vulnerabilities via security@example.com.
  EOT
}
```

### Multiple Repositories (for_each Pattern)

```hcl
locals {
  repos = {
    api = {
      description = "Public API"
      visibility  = "public"
      topics      = ["api", "public"]
    }
    worker = {
      description = "Background workers"
      visibility  = "private"
      topics      = ["worker", "queue"]
    }
  }
}

module "repos" {
  source       = "../modules/repo_hardening"
  for_each     = local.repos
  organization = var.organization
  name         = each.key
  description  = each.value.description
  visibility   = each.value.visibility
  topics       = each.value.topics
}
```

### Adding Environment Protection Reviewers

```hcl
module "repo_with_envs" {
  source       = "../modules/repo_hardening"
  organization = var.organization
  name         = "deploy-targets"

  environments = {
    production = { reviewers = ["team:platform-team"] }
    staging    = { reviewers = ["user:alice", "user:bob"] }
  }
}
```

Reviewers use raw strings today; you can standardize a prefix convention (e.g. `team:`) until native team/user type distinction variables are added.

### Organization Hardening

```hcl
module "org" {
  source       = "../modules/org_hardening"
  organization = var.organization

  billing_email = "billing@your-org.example"

  default_repository_permission = "read"

  members_can_create_public_repositories   = false
  members_can_create_private_repositories  = false
  members_can_create_internal_repositories = false
  members_can_create_pages                 = false
  members_can_fork_private_repositories    = false
}
```

### Combining Org + Multiple Repos

```hcl
module "org" { # apply first (or same apply)
  source       = "../modules/org_hardening"
  organization = var.organization
  billing_email = var.billing_email
}

module "repos" {
  source       = "../modules/repo_hardening"
  for_each     = var.repo_definitions
  organization = var.organization
  name         = each.key
  description  = each.value.description
  visibility   = each.value.visibility
  topics       = coalesce(each.value.topics, [])
  dependabot_updates = coalesce(each.value.dependabot_updates, {})
}
```

Where `var.repo_definitions` could be defined in `terraform.tfvars` as:

```hcl
repo_definitions = {
  frontend = {
    description = "UI frontend"
    visibility  = "public"
    topics      = ["frontend", "react"]
    dependabot_updates = {
      npm = { directory = "/" schedule_interval = "weekly" }
    }
  }
  backend = {
    description = "Core API"
    visibility  = "private"
    topics      = ["api", "go"]
  }
}
```

### Output Consumption Example

```hcl
output "api_repo_full_name" {
  value = module.repos["api"].repository_full_name
}
```

### Minimal Variable Definitions File (`variables.tf` root example)

```hcl
variable "organization" { type = string }
variable "billing_email" { type = string }
variable "repo_definitions" {
  type = map(object({
    description        = string
    visibility         = string
    topics             = optional(list(string))
    dependabot_updates = optional(map(object({ directory = string, schedule_interval = string })))
  }))
  default = {}
}
```

These patterns let you scale to many repositories with a single apply while preserving secure defaults.

## Roadmap

* Add optional CodeQL default configuration
* Add OpenSSF Scorecard scheduled workflow provisioning
* Add reusable workflows to central security repo
* Add org-level branch protection defaults when API supports more knobs
* Policy as Code (OPA/conftest) examples for drift prevention

## Control Matrix

See `docs/controls-matrix.md` for a mapping of OpenSSF GitHub SCM Best Practices to the Terraform resources / variables in this project, including implementation status (Implemented / Partial / Planned / Out-of-scope).

## Disclaimer

Not every OpenSSF recommendation is currently mappable 1:1 to Terraform provider resources. Items not yet supported are documented as TODO inside the module.
