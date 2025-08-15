output "id" { value = github_repository.this.id }
output "full_name" { value = "${var.organization}/${var.name}" }
