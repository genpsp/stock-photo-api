resource "google_artifact_registry_repository" "stock_photo_api_repository" {
  location      = var.region
  repository_id = var.project_id
  description   = "StockPhoto API repository"
  format        = "DOCKER"
}
