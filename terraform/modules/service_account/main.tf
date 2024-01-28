resource "google_service_account" "github_actions_service_account" {
  project      = var.project_id
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}

output "github_service_account_email" {
  value = google_service_account.github_actions_service_account.email
}
output "github_service_account_name" {
  value = google_service_account.github_actions_service_account.name
}
