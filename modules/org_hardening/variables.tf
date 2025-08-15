terraform {
  required_version = ">= 1.6.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}

variable "organization" {
  description = "GitHub organization name"
  type        = string
}

variable "default_repository_permission" {
  description = "none | read | write | admin - default base permission for members"
  type        = string
  default     = "read"
}

variable "billing_email" {
  description = "Billing email required by github_organization_settings"
  type        = string
  validation {
    condition     = can(regex("^\\S+@\\S+\\.\\S+$", var.billing_email))
    error_message = "Please provide a valid billing email address."
  }
}

variable "members_can_create_public_repositories" {
  type    = bool
  default = false
}
variable "members_can_create_private_repositories" {
  type    = bool
  default = false
}
variable "members_can_create_internal_repositories" {
  type    = bool
  default = false
}
variable "members_can_create_pages" {
  type    = bool
  default = false
}
variable "members_can_fork_private_repositories" {
  type    = bool
  default = false
}

variable "web_commit_signoff_required" {
  type    = bool
  default = true
}

variable "advanced_security_enabled_for_new_repositories" {
  type    = bool
  default = true
}
variable "dependabot_alerts_enabled_for_new_repositories" {
  type    = bool
  default = true
}
variable "secret_scanning_enabled_for_new_repositories" {
  type    = bool
  default = true
}
variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  type    = bool
  default = true
}
