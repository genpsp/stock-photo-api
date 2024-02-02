resource "google_service_account" "github_actions_service_account" {
  project      = var.project_id
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}

resource "google_service_account" "cloudrun_service_account" {
  account_id   = "cloudrun-service-account"
  display_name = "API Cloud Run Service Account"
}

resource "google_project_iam_member" "cloudrun_cloudsql_client" {
  project    = var.project_id
  role       = "roles/cloudsql.client"
  member     = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
  # depends_on = [google_service_account.cloudrun_service_account]
}

resource "google_project_iam_member" "cloudrun_secret_manager_secret_accessor" {
  project    = var.project_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
  # depends_on = [google_service_account.cloudrun_service_account]
}

output "cloudrun_service_account_email" {
  value = google_service_account.cloudrun_service_account.email
}
output "github_service_account_email" {
  value = google_service_account.github_actions_service_account.email
}
output "github_service_account_name" {
  value = google_service_account.github_actions_service_account.name
}
