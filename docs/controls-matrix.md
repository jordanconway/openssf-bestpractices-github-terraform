# OpenSSF GitHub SCM Best Practices Control Matrix

Legend: Status = Implemented | Partial | Planned | Out-of-scope.
If Status is Planned, the Reason column states whether this is a current Terraform provider limitation (Provider Limitation) or simply not yet wired in this module (Module TODO), or a reporting-only soft control (Reporting / Non-config).

## Continuous Integration / Continuous Deployment

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| Workflows cannot self-approve PRs | Planned | (Future: org / repo actions policy) | Mitigated via human review requirement | Provider Limitation (no flag) |
| Restrict GitHub Actions to selected repositories | Planned | (Future: organization actions policy) | Need central allow-list enforcement | Provider Limitation (org-level policy unsupported) |
| Limit Actions to verified or explicitly trusted actions | Planned | `actions_allowed_actions` (coarse) | Fine-grained patterns not yet stable | Provider Limitation (granular allow patterns) |
| Default workflow token permission read-only | Planned | (Future: actions token permission) | Currently manual in UI | Provider Limitation (attribute missing) |

## Enterprise (Platform-Wide)

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| Enforce enterprise two-factor authentication | Out-of-scope | — | Needs enterprise admin context | Provider Limitation (enterprise scope unsupported) |
| Block members changing repository visibility | Out-of-scope | — | Enterprise policy missing | Provider Limitation |
| Restrict public repository creation at enterprise | Partial | `github_organization_settings.members_can_create_public_repositories=false` | Org layer only | Provider Limitation (enterprise policy) |
| Disallow inviting outside collaborators | Out-of-scope | — | Awaiting API/resource | Provider Limitation |
| Enforce Single Sign-On | Out-of-scope | External IdP | Managed outside Terraform module | External Dependency |
| Disallow forking of private/internal repositories | Partial | `github_organization_settings.members_can_fork_private_repositories=false` | Partial coverage | Provider Limitation (granular forking controls) |

## Members / Access Control

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| Organization should have fewer than three owners | Planned | (Future: data/report module) | Requires periodic analysis | Reporting / Non-config |
| Organization admins active in last 6 months | Planned | (Future: script/workflow) | Activity metric | Reporting / Non-config |
| Organization members active in last 6 months | Planned | (Future: script/workflow) | Activity metric | Reporting / Non-config |

## Organizational Management

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| Enforce organization two-factor authentication | Planned | (Future: `github_organization_settings` flag) | Await provider exposure | Provider Limitation |
| Restrict default member permissions | Implemented | `github_organization_settings.default_repository_permission` | Default is hardened | — |
| Only admins can create public repositories | Implemented | `github_organization_settings.members_can_create_public_repositories=false` | Control enforced | — |
| Webhooks must require SSL | Planned | (Future: webhook mgmt) | Need creation + scan tooling | Module TODO (implementable) |
| Webhooks must include a secret | Planned | (Future: `github_repository_webhook`) | Need variable & resource wiring | Module TODO (implementable) |

## Repository Protections

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| Repository updated at least quarterly | Planned | (Future: reporting module) | Non-config metric | Reporting / Non-config |
| Default branch requires code review | Implemented | `github_branch_protection.required_pull_request_reviews` | PR reviews enforced | — |
| Default branch requires linear history | Implemented | `github_branch_protection.required_linear_history` | Linear history on | — |
| Default workflow token permission read-only | Planned | (Future: actions permission attr) | Duplicate listing | Provider Limitation |
| Scorecard score above 7 | Planned | (Future: scorecard workflow) | Will add workflow | Module TODO (implementable) |
| Default branch requires >=2 reviewers | Implemented | `...required_pull_request_reviews.required_approving_review_count=2` | 2 approvals | — |
| All required checks must pass before merge | Implemented | `github_branch_protection.required_status_checks` strict | Status checks gating | — |
| Branch must be up to date before merge | Planned | (Future explicit flag if added) | Partially via strict=true | Provider Limitation (no dedicated flag) |
| Force pushes disallowed | Implemented | `github_branch_protection.allows_force_pushes=false` | Hardened default | — |
| Default branch protected | Implemented | `github_branch_protection.pattern` | Protection active | — |
| Branch deletion disallowed | Implemented | `github_branch_protection.allows_deletions=false` | Hardened default | — |
| Dependency review enabled | Partial | `github_repository_security_analysis.advanced_security` | Broad enable; granular pending | Provider Limitation (no fine-grained dep review toggle) |
| Vulnerability alerts enabled | Implemented | `github_repository.vulnerability_alerts` + security analysis | Alerts enabled | — |
| Forking disallowed | Planned | (Future: add `allow_forking` var) | Add variable & pass-through | Module TODO (implementable) |
| Conversation resolution required | Implemented | `github_branch_protection.require_conversation_resolution` | Threads must resolve | — |
| Webhook secret configured | Planned | (Future: `github_repository_webhook`) | Need resource & variable | Module TODO (implementable) |
| Signed commits required | Implemented | `github_branch_protection.require_signed_commits` | Signed commits enforced | — |
| Re-approval after code changes required | Implemented | `dismiss_stale_reviews=true` | Stale approvals dismissed | — |
| Restrict who can push to protected branch | Planned | (Future: restrictions block vars) | Need teams/users lists | Module TODO (implementable) |
| Fewer than three admins at repo level | Planned | (Future: report) | Observability only | Reporting / Non-config |
| Code owners only can approve | Implemented | Code owners reviews + CODEOWNERS file | Owner review enforced | — |
| Restrict who can dismiss reviews | Planned | (Future: dismissal restrictions block) | Need teams/users vars | Module TODO (implementable) |
| Webhooks require SSL (repo) | Planned | (Future: webhook resource with `insecure_ssl=0`) | Enforce secure transport | Module TODO (implementable) |

## Security Features

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| Secret scanning enabled | Implemented | `github_repository_security_analysis.secret_scanning="enabled"` | Enabled | — |
| Secret scanning push protection | Implemented | `github_repository_security_analysis.secret_scanning_push_protection="enabled"` | Enabled | — |
| Advanced Security enabled (code scanning default) | Implemented | `github_repository_security_analysis.advanced_security="enabled"` + `code_scanning_default_setup="enabled"` | Billing impact | — |
| Dependabot security updates | Implemented | `github_repository_dependabot_security_updates.enabled=true` | Security patches | — |
| Dependabot version updates configured | Implemented | `github_repository_file.dependabot` + var `dependabot_updates` | Version updates | — |
| Security policy file present | Implemented | `github_repository_file.security_md` | SECURITY.md present | — |

## Governance & Files

| Practice | Status | Terraform Mapping (resources / variables) | Notes | Reason |
|----------|--------|-------------------------------------------|-------|--------|
| CODEOWNERS present | Implemented | `github_repository_file.codeowners` + var `codeowners_content` | Enables owner review | — |
| License file present | Planned | (Future: validation helper or file resource) | To enforce license presence | Module TODO (implementable) |
| Code of Conduct present | Planned | (Future: variable + file resource) | Governance enhancement | Module TODO (implementable) |

## Gaps & Next Steps

| # | Planned Enhancement | Rationale |
|---|---------------------|-----------|
| 1 | Add branch push & dismissal restriction variables/resources | Complete branch protection parity |
| 2 | Add `allow_forking` enforcement | Meet fork control recommendation |
| 3 | Provision OpenSSF Scorecard workflow | Automate score tracking |
| 4 | Reporting / compliance module (non-config checks) | Surface drift & soft controls |
| 5 | Webhook management (SSL + secret enforcement) | Secure integration points |
| 6 | License & Code of Conduct enforcement | Governance completeness |
| 7 | Track provider updates (token perms, dependency review granularity) | Close remaining gaps |

## Updating This Matrix

When adding a new control:
1. Add or update the appropriate row with Status and full Terraform mapping.
2. If the control is non-config (monitoring/reporting), mark Mapping as future reporting.
3. Update Gaps & Next Steps if it introduces new follow-on work.
