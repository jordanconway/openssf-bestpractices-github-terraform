terraform {
  required_version = ">= 1.6.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}

# Inputs
variable "organization" {
  description = "GitHub organization name"
  type        = string
}

variable "name" {
  description = "Repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = null
}

variable "homepage_url" {
  description = "Homepage URL"
  type        = string
  default     = null
}

variable "visibility" {
  description = "public | private | internal"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "visibility must be public, private, or internal"
  }
}

variable "topics" {
  description = "List of repository topics"
  type        = list(string)
  default     = []
}

variable "has_issues" {
  description = "Enable GitHub Issues"
  type        = bool
  default     = true
}
variable "has_discussions" {
  description = "Enable GitHub Discussions"
  type        = bool
  default     = false
}
variable "has_projects" {
  description = "Enable (classic) Projects"
  type        = bool
  default     = false
}
variable "has_wiki" {
  description = "Enable Wiki"
  type        = bool
  default     = false
}
variable "is_template" {
  description = "Mark repository as a template"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = false
}
variable "allow_squash_merge" {
  description = "Allow squash merge strategy"
  type        = bool
  default     = true
}
variable "allow_rebase_merge" {
  description = "Allow rebase merge strategy"
  type        = bool
  default     = false
}
variable "delete_branch_on_merge" {
  description = "Automatically delete head branch after merge"
  type        = bool
  default     = true
}
variable "enforce_admins" {
  description = "Apply branch protection rules to admins"
  type        = bool
  default     = true
}
variable "required_approving_review_count" {
  description = "Number of required approving PR reviews"
  type        = number
  default     = 2
}
variable "require_code_owner_reviews" {
  description = "Require CODEOWNERS approval on PRs"
  type        = bool
  default     = true
}
variable "dismiss_stale_reviews" {
  description = "Dismiss stale PR approvals when new commits are pushed"
  type        = bool
  default     = true
}
variable "require_signed_commits" {
  description = "Require signed commits on the protected branch"
  type        = bool
  default     = true
}
variable "required_linear_history" {
  description = "Require linear git history (no merge commits)"
  type        = bool
  default     = true
}
variable "require_conversation_resolution" {
  description = "Require all review conversations to be resolved before merging"
  type        = bool
  default     = true
}
variable "allow_force_pushes" {
  description = "Permit force pushes to the protected branch"
  type        = bool
  default     = false
}
variable "allow_deletions" {
  description = "Permit deletion of the protected branch"
  type        = bool
  default     = false
}
variable "required_status_checks" {
  description = "List of status check contexts required before merging into the protected branch"
  type        = list(string)
  default     = []
}
variable "secret_scanning" {
  description = "Enable GitHub secret scanning"
  type        = bool
  default     = true
}
variable "secret_scanning_push_protection" {
  description = "Enable push protection for detected secrets"
  type        = bool
  default     = true
}
variable "dependabot_security_updates" {
  description = "Enable Dependabot security update PRs"
  type        = bool
  default     = true
}
variable "vulnerability_alerts" {
  description = "Enable GitHub vulnerability (Dependabot) alerts"
  type        = bool
  default     = true
}
# NOTE: Actions fine-grained allow lists are currently omitted due to provider attribute instability.
variable "actions_allowed_actions" {
  description = "Simplified actions policy (all, local_only)"
  type        = string
  default     = "all"
}

variable "codeowners_content" {
  description = "Optional CODEOWNERS file content to ensure code owner reviews work"
  type        = string
  default     = null
}

variable "security_policy_content" {
  description = "Optional SECURITY.md content (if null, presence not enforced)"
  type        = string
  default     = null
}

variable "dependabot_updates" {
  description = "Configure Dependabot version updates (map of package-ecosystem => directory)"
  type = map(object({
    directory         = string
    schedule_interval = string # daily, weekly, monthly
  }))
  default = {}
}

variable "default_branch" {
  description = "Default branch name"
  type        = string
  default     = "main"
}
