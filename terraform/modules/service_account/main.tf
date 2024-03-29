resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}
resource "google_project_iam_member" "ga_repository_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
resource "google_project_iam_member" "ga_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
resource "google_project_iam_member" "ga_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
resource "google_project_iam_member" "ga_cloudrun_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
resource "google_project_iam_member" "ga_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
resource "google_storage_bucket_iam_member" "ga_bucket_erd_admin" {
  bucket = var.erd_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_service_account" "cloudrun" {
  account_id   = "cloudrun-service-account"
  display_name = "API Cloud Run Service Account"
}
resource "google_project_iam_member" "cloudrun_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}
resource "google_project_iam_member" "cloudrun_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}
resource "google_project_iam_member" "cloudrun_storage_user" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}

output "cloudrun_sa_email" {
  value = google_service_account.cloudrun.email
}
output "github_sa_email" {
  value = google_service_account.github_actions.email
}
output "github_sa_name" {
  value = google_service_account.github_actions.name
}
