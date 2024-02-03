resource "google_iam_workload_identity_pool" "identity_pool" {
  workload_identity_pool_id = "identity-pool"
  project                   = var.project_id
  display_name              = "Identity Pool"
  description               = "Workload Identity Pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_provider_id = "github-actions-pool-provider"
  workload_identity_pool_id          = google_iam_workload_identity_pool.identity_pool.workload_identity_pool_id
  project                            = var.project_id
  display_name                       = "GitHub Provider"
  description                        = "GitHub provider for Workload Identity Federation"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
    # allowed_audiences = [var.github_api_repository]
  }
}

resource "google_service_account_iam_member" "ga_workload_identity_user" {
  service_account_id = var.github_sa_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/attribute.repository/${var.github_api_repository}"
}

output "identity_pool_name" {
  value = google_iam_workload_identity_pool.identity_pool.name
}
