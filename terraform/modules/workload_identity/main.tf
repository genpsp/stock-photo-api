resource "google_iam_workload_identity_pool" "identity_pool" {
  workload_identity_pool_id = "identity-pool-${var.env}"
  provider                  = google
  project                   = var.project_id
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_provider_id = "github-actions-pool-provider-${var.env}"
  workload_identity_pool_id          = google_iam_workload_identity_pool.identity_pool.workload_identity_pool_id
  provider                           = google
  project                            = var.project_id
  display_name                       = "GitHub Provider"
  description                        = "GitHub provider for Workload Identity Federation"
  attribute_mapping = {
    "google.subject" = "assertion.repository"
  }

  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
    allowed_audiences = [var.github_repository]
  }
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = var.github_service_account_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/attribute.repository/${var.github_repository}"
}
