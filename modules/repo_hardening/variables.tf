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
  type    = bool
  default = true
}
variable "has_discussions" {
  type    = bool
  default = false
}
variable "has_projects" {
  type    = bool
  default = false
}
variable "has_wiki" {
  type    = bool
  default = false
}
variable "is_template" {
  type    = bool
  default = false
}

variable "allow_merge_commit" {
  type    = bool
  default = false
}
variable "allow_squash_merge" {
  type    = bool
  default = true
}
variable "allow_rebase_merge" {
  type    = bool
  default = false
}
variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "enforce_admins" {
  type    = bool
  default = true
}
variable "required_approving_review_count" {
  type    = number
  default = 2
}
variable "require_code_owner_reviews" {
  type    = bool
  default = true
}
variable "dismiss_stale_reviews" {
  type    = bool
  default = true
}
variable "require_signed_commits" {
  type    = bool
  default = true
}
variable "required_linear_history" {
  type    = bool
  default = true
}
variable "require_conversation_resolution" {
  type    = bool
  default = true
}
variable "allow_force_pushes" {
  type    = bool
  default = false
}
variable "allow_deletions" {
  type    = bool
  default = false
}

variable "required_status_checks" {
  description = "List of required status check contexts"
  type        = list(string)
  default     = []
}

variable "secret_scanning" {
  type    = bool
  default = true
}
variable "secret_scanning_push_protection" {
  type    = bool
  default = true
}
variable "dependabot_security_updates" {
  type    = bool
  default = true
}
variable "vulnerability_alerts" {
  type    = bool
  default = true
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
