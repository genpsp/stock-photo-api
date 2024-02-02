resource "google_artifact_registry_repository" "stock_photo_api_repository" {
  location      = var.region
  repository_id = "stock-photo-api-repository"
  description   = "StockPhoto API repository"
  format        = "DOCKER"
}

output "stock_photo_api_repository_id" {
  value = google_artifact_registry_repository.stock_photo_api_repository.id
}
